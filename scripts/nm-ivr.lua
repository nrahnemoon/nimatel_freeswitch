require('nm-account')
require('nm-db')
require('nm-lib')

Ivr = {};
Ivr.__index = Ivr;

function Ivr.create(db)
  local ivr = {};
  setmetatable(ivr, Ivr);
  ivr.db = db;
  return ivr;
end

function Ivr:testDigits(digits)
  if digits == "0" then
    self:transferToOperator();
  elseif digits == "9" then
    self:start();
  end
end

function Ivr:start()
  local digits = session:playAndGetDigits(1, 12, 1, 4000, "",
      "phrase:welcome_enter_pin_cc", "", "\\d+");
  self:handleStart(digits);
end

function Ivr:handleStart(digits)
  self:testDigits(digits);
  if digits == "1" then
    self:newAccount();
  elseif digits:len() == 12 then
    self:accountLookup(digits);
    self:readBalanceGetDestination();
  else
    local digits = session:playAndGetDigits(1, 12, 1, 3000, "",
        "phrase:invalid_entry_try_again", "", "\\d+");
    self:handleStart(digits);
  end
end

function Ivr:accountLookup(digits)
  self.account = self.db:lookupAccount(digits);
  if self.account == nil then
    local digits = session:playAndGetDigits(1, 12, 1, 3000, "",
        "phrase:invalid_pin_try_again", "", "\\d+");
    self:handleStart(digits);
  end
end

function Ivr:readBalance()
  session:sayPhrase("read_balance", self.account.balance, "en");
end

function Ivr:getDestination()
  local digits = session:playAndGetDigits(1, 128, 1, 4000, "#",
        "phrase:read_balance_enter_destination", "", "\\d+");
end

function Ivr:transferToOperator()
  -- TODO(nima)
  session:hangup();
  exit();
end

