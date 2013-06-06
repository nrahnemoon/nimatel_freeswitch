Account = {}
Account.__index = Account;

function Account.init(pin, balance)
  local account = {};
  setmetatable(account, Account);
  account.pin = pin;
  account.balance = balance;
  return account;
end

