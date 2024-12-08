import express from 'express';
import bodyParser from 'body-parser';
import jwt from 'jsonwebtoken';
import { TezosToolkit } from '@taquito/taquito';
import { InMemorySigner } from '@taquito/signer';

const app = express();
const port = 3000;

app.use(bodyParser.json());

// Secret key for JWT
const JWT_SECRET = 'your-secret-key';

// Tezos configuration
const TEZOS_RPC_URL = 'https://ghostnet.smartpy.io'; // Using Ghostnet testnet
const ADMIN_PRIVATE_KEY = 'your-admin-private-key'; // Replace with your actual private key
const TOKEN_CONTRACT_ADDRESS = 'your-token-contract-address'; // Replace with your deployed token contract address

const tezos = new TezosToolkit(TEZOS_RPC_URL);
tezos.setProvider({ signer: new InMemorySigner(ADMIN_PRIVATE_KEY) });

// Mock user database (in a real app, you'd use a proper database)
const users = [
  { id: 1, username: 'user1', password: 'password1', tezosAddress: 'tz1...' },
  { id: 2, username: 'user2', password: 'password2', tezosAddress: 'tz2...' },
];

// Middleware to verify JWT token
const verifyToken = (req: express.Request, res: express.Response, next: express.NextFunction) => {
  const token = req.headers['authorization'];
  if (!token) return res.status(403).send({ auth: false, message: 'No token provided.' });

  jwt.verify(token.split(' ')[1], JWT_SECRET, (err, decoded: any) => {
    if (err) return res.status(500).send({ auth: false, message: 'Failed to authenticate token.' });
    req.userId = decoded.id;
    next();
  });
};

// Login route
app.post('/login', (req, res) => {
  const { username, password } = req.body;
  const user = users.find(u => u.username === username && u.password === password);

  if (!user) {
    return res.status(401).send({ auth: false, message: 'Invalid credentials' });
  }

  const token = jwt.sign({ id: user.id }, JWT_SECRET, { expiresIn: 86400 }); // expires in 24 hours
  res.status(200).send({ auth: true, accessToken: token, tezosAddress: user.tezosAddress });
});

// Get token balance route
app.get('/token_balance', verifyToken, async (req: express.Request, res: express.Response) => {
  try {
    const user = users.find(u => u.id === req.userId);
    if (!user) {
      return res.status(404).send({ message: 'User not found' });
    }

    const contract = await tezos.contract.at(TOKEN_CONTRACT_ADDRESS);
    const storage: any = await contract.storage();
    const balance = await storage.balances.get(user.tezosAddress);

    res.status(200).send({ balance: balance ? balance.toNumber() : 0 });
  } catch (error) {
    console.error('Error fetching token balance:', error);
    res.status(500).send({ message: 'Error fetching token balance' });
  }
});

// Issue tokens route
app.post('/issue_tokens', verifyToken, async (req: express.Request, res: express.Response) => {
  try {
    const { amount, recipient } = req.body;
    const contract = await tezos.contract.at(TOKEN_CONTRACT_ADDRESS);
    
    const op = await contract.methods.mint(recipient, amount).send();
    await op.confirmation();

    res.status(200).send({ message: 'Tokens issued successfully', operationHash: op.hash });
  } catch (error) {
    console.error('Error issuing tokens:', error);
    res.status(500).send({ message: 'Error issuing tokens' });
  }
});

// Convert tokens route (burn tokens)
app.post('/convert_tokens', verifyToken, async (req: express.Request, res: express.Response) => {
  try {
    const { amount } = req.body;
    const user = users.find(u => u.id === req.userId);
    if (!user) {
      return res.status(404).send({ message: 'User not found' });
    }

    const contract = await tezos.contract.at(TOKEN_CONTRACT_ADDRESS);
    
    const op = await contract.methods.burn(user.tezosAddress, amount).send();
    await op.confirmation();

    res.status(200).send({ message: 'Tokens converted successfully', operationHash: op.hash });
  } catch (error) {
    console.error('Error converting tokens:', error);
    res.status(500).send({ message: 'Error converting tokens' });
  }
});

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});