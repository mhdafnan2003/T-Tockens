import smartpy as sp

class Token(sp.Contract):
    def __init__(self, admin, token_name, token_symbol, initial_supply):
        self.init(
            balances = sp.big_map({admin: initial_supply}),
            admin = admin,
            paused = False,
            token_name = token_name,
            token_symbol = token_symbol,
            total_supply = initial_supply
        )

    @sp.entry_point
    def transfer(self, params):
        sp.verify(~self.data.paused, "TOKEN_PAUSED")
        sp.verify(self.data.balances[params.from_] >= params.amount, "INSUFFICIENT_BALANCE")
        self.data.balances[params.from_] = sp.as_nat(self.data.balances[params.from_] - params.amount)
        self.data.balances[params.to] = self.data.balances.get(params.to, 0) + params.amount

    @sp.entry_point
    def mint(self, params):
        sp.verify(sp.sender == self.data.admin, "NOT_ADMIN")
        self.data.balances[params.to] = self.data.balances.get(params.to, 0) + params.amount
        self.data.total_supply += params.amount

    @sp.entry_point
    def burn(self, params):
        sp.verify(self.data.balances[sp.sender] >= params.amount, "INSUFFICIENT_BALANCE")
        self.data.balances[sp.sender] = sp.as_nat(self.data.balances[sp.sender] - params.amount)
        self.data.total_supply = sp.as_nat(self.data.total_supply - params.amount)

    @sp.entry_point
    def set_pause(self, params):
        sp.verify(sp.sender == self.data.admin, "NOT_ADMIN")
        self.data.paused = params.paused

@sp.add_test(name = "Token")
def test():
    scenario = sp.test_scenario()
    admin = sp.address("tz1adminaddress")
    alice = sp.address("tz1aliceaddress")
    bob = sp.address("tz1bobaddress")
    
    token = Token(admin, "MyToken", "MTK", 1000000)
    scenario += token
    
    scenario.h2("Test minting")
    token.mint(to=alice, amount=100).run(sender=admin)
    
    scenario.h2("Test transfers")
    token.transfer(from_=alice, to=bob, amount=10).run(sender=alice)
    
    scenario.h2("Test burning")
    token.burn(amount=5).run(sender=bob)
    
    scenario.h2("Test pausing")
    token.set_pause(paused=True).run(sender=admin)
    token.transfer(from_=alice, to=bob, amount=10).run(sender=alice, valid=False)