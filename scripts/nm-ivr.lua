require('nm-account')
require('nm-db')
require('nm-lib')
require('nmw-wrate')

Ivr = {};
Ivr.__index = Ivr;

function Ivr.create(db, cc)
  local ivr = {};
  setmetatable(ivr, Ivr);
  ivr.db = db;
  ivr.cc = cc;
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

function Ivr:readBalanceGetDestination()
  local digits = session:playAndGetDigits(1, 128, 1, 4000, "#",
        "phrase:read_balance_enter_destination:" .. self.account.balance, "", "\\d+");
  self:testDigits(digits)
  self.region = self.db:lookupRegion(digits);
  freeswitch.consoleLog('INFO', "\n\n\n\n\n\nRegion = " .. self.region .. "\n\n\n\n\n");
end

function Ivr:transferToOperator()
  -- TODO(nima)
  session:hangup();
  exit();
end

function Ivr:newAccount()
  local digits = session:playAndGetDigits(1, 1, 1, 10000, "", "cc_ready.wav", "", "\\d+");
  self:handleNewAccount(digits);
end

function Ivr:handleNewAccount(digits)
  self:testDigits(digits);
  if digits == "1" then
    self:readCcNum();
  else
    local digits = session:playAndGetDigits(1, 1, 1, 10000, "", "phrase:back_main_menu_or_ready_cc", "", "\\d+");
    self:handleNewAccount(digits);
  end
end

function Ivr:readCcNum()
  local digits = session:playAndGetDigits(1, 16, 1, 3000, "", "phrase:enter_cc.wav", "", "\\d+");
  self:handleReadCcNum(digits)
end

function Ivr:handleReadCcNum(digits)
  self:testDigits(digits);
  if !Cc.validateNumber(digits) then
  elseif !Cc.validBrand(digits) then
  end
end 
