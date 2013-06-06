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
  local digits = session:playAndGetDigits(1, 12, 1, 3000, "",
      "phrase:welcome_enter_pin_cc", "", "\\d+");
  self:handleStart(digit);
end

function Ivr:handleStart(digits)
  self:testDigits(digits);
  if digits == "1" then
    self:newAccount();
  elseif tableLength(digits == 12) then
    self:accountLookup(digits);
  else
    local digits = session:playAndGetDigits(1, 12, 1, 3000, "",
        "phrase:welcome_enter_pin_cc", "", "\\d+");
    self:handleStart(digit);
  end
end

function Ivr:accountLookup(digits)
  self.account = self.db:lookupAccount(digits);
  if self.account == nil then
    session:
  end
end

function Ivr:transferToOperator()
  -- TODO(nima)
end

