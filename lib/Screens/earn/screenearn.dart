import 'package:flutter/material.dart';

class Screenearn extends StatelessWidget {
   Screenearn({super.key});
final ValueNotifier<double> balance = ValueNotifier<double>(0.0);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFC2E59C),
              Color(0xFF64B3F4),
            ],
          ),
        ),
        child: Column(
          children: [
            // First part: Custom AppBar-like widget
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(Icons.person),
                      ),
                      const SizedBox(width: 8),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Alfin KJ',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          Text('@alfinkj',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black54)),
                        ],
                      ),
                          
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                            icon: const Icon(Icons.notifications,
                                color: Colors.black),
                            onPressed: () {}),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                            icon:
                                const Icon(Icons.settings, color: Colors.black),
                            onPressed: () {}),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Second part: 3 columns with text
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Balance', style: TextStyle(fontSize: 14)),
                ValueListenableBuilder<double>(
                  valueListenable: balance,
                  builder: (context, value, child) {
                    return Text(
                      '\$${value.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.account_balance_wallet, color: Colors.black),
                            onPressed: () => _showWithdrawDialog(context),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text('Withdraw'),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.swap_horiz, color: Colors.black),
                            onPressed: () {},
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text('Swap'),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon:  const Icon(Icons.send, color: Colors.black),
                            onPressed: () => _showSendDialog(context),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text('Send'),
                      ],
                    ),
                  ],
                ),
              ],
            )),
            // Third part: Bottom sheet with curved corners
            Container(
              height: 300, // Increased height to a more standard size
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    'Transaction History',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  for (int i = 0; i < 10; i++)
                    ListTile(
                      leading: Icon(
                        i % 2 == 0 ? Icons.arrow_upward : Icons.arrow_downward,
                        color: i % 2 == 0 ? Colors.red : Colors.green,
                      ),
                      title: Text(
                        'Transaction ${i + 1}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        DateTime.now().subtract(Duration(days: i)).toString().split(' ')[0],
                        style: const TextStyle(color: Colors.white70),
                      ),
                      trailing: Text(
                        '${(i + 1) * 10.0} XTZ',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _showSendDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController amountController = TextEditingController();
        return AlertDialog(
          title: const Text('Send'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              
              TextField(
                controller: amountController,
                decoration: const InputDecoration(
                  labelText: 'Enter amount to send',
                  hintText: 'Enter a number',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  if (amountController.text.isNotEmpty) {
                    double? amount = double.tryParse(amountController.text);
                    if (amount != null) {
                      balance.value += amount;
                      Navigator.of(context).pop();
                    }
                  }
                },
              ),
              const SizedBox(height: 16),
              
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
        
      },
    );
  }
  void _showWithdrawDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController amountController = TextEditingController();
        return AlertDialog(
          title: const Text('Withdraw'),
          content: TextField(
            controller: amountController,
            decoration: const InputDecoration(labelText: 'Enter amount to withdraw'),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Withdraw'),
              onPressed: () {
                if (amountController.text.isNotEmpty) {
                  double? amount = double.tryParse(amountController.text);
                  if (amount != null && amount <= balance.value) {
                    balance.value -= amount;
                    Navigator.of(context).pop();
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
}



