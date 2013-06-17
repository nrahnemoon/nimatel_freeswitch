require('nm-lib');
require('socket');
local https = require("ssl.https")
ltn12 = require("ltn12")
require("LuaXML")

Cc = {};
Cc.__index = Cc;

Cc.brands = {
  [10] = "Invalid",
  [20] = "American Express",
  [30] = "Bankcard",
  [40] = "China UnionPay",
  [50] = "Diners Club Carte Blanche",
  [60] = "Diners Club enRoute",
  [70] = "Diners Club International",
  [80] = "Diners Club",
  [90] = "Discover Card",
  [100] = "InstaPayment",
  [110] = "JCB",
  [120] = "Laser",
  [130] = "Maestro",
  [140] = "MasterCard",
  [150] = "Solo",
  [160] = "Switch",
  [170] = "Visa",
  [180] = "Visa Electron",
};

function Cc.create(merchantLogin, merchantPassword)
  local cc = {};
  setmetatable(cc, Cc);
  cc.merchantLogin = merchantLogin;
  cc.merchantPassword = merchantPassword;
  return cc;
end

function Cc:createCustomerProfile(phoneNumber)
  
end

function Cc.validateNumber(number)
  number = tostring(number);
  local reversed = string.reverse(number);
  local sum = 0;
  for index = 1, #reversed do
    local curr = reversed:sub(index, index);
    curr = tonumber(curr);
    if (index % 2 == 0) then
      sum = sum + curr;
    else
      local evenMultiplied = tostring(curr * 2);
      for index = 1, #evenMultiplied do
        sum = sum + tonumber(evenMultiplied:sub(index, index));
      end
    end
  end 
  return (sum % 10 == 0)
end

function Cc.validateNumber(number)
  number = string.reverse(number)

  local oddSum = 0;
  --sum odd digits
  for index = 1, number:len(), 2 do
    oddSum = oddSum + number:sub(index, index);
  end

  --evens
  local evenSum = 0;
  for index = 2, number:len(), 2 do
    local doubled = number:sub(index, index) * 2;
    doubled = string.gsub(doubled, '(%d)(%d)', function(a, b) return a + b end);
    evenSum = evenSum + doubled;
  end

  local total = oddSum + evenSum;
  if total % 10 == 0 then
    return true
  end
  return false
end

function Cc.getBrand(number)
  if (string.starts(number, "34") or string.starts(number, "37")) then
    return 20; -- American Express
  elseif (string.starts(number, "51") or string.starts(number, "52") or string.starts(number, "53") or
    string.starts(number, "54") or string.starts(number, "55")) then
    return 140; -- MasterCard
  elseif (string.starts(number, "6011") or string.starts(number, "622") or
    string.starts(number, "644") or string.starts(number, "645") or string.starts(number, "646") or
    string.starts(number, "647") or string.starts(number, "648") or string.starts(number, "649") or
    string.starts(number, "65")) then
    return 90; -- Discover Card
  elseif (string.starts(number, "4903") or string.starts(number, "4905") or string.starts(number, "4911") or
    string.starts(number, "4936") or string.starts(number, "564182") or string.starts(number, "633110") or
    string.starts(number, "6333") or string.starts(number, "6759")) then
    return 160; -- Switch
  elseif (string.starts(number, "4026") or string.starts(number, "417500") or string.starts(number, "4405") or
    string.starts(number, "4508") or string.starts(number, "4844") or string.starts(number, "4913") or
    string.starts(number, "4917")) then
    return 180; -- Visa Electron
  elseif (string.starts(number, "4")) then
    return 170; -- Visa
  elseif (string.starts(number, "5610") or string.starts(number, "56022")) then
    return 30; -- Bankcard
  elseif (string.starts(number, "62") or string.starts(number, "88")) then
    return 40; -- China UnionPay
  elseif (string.starts(number, "30")) then
    return 50; -- Diners Club Carte Blanche
  elseif (string.starts(number, "2014") or string.starts(number, "2149")) then
    return 60; -- Diners Club enRoute
  elseif (string.starts(number, "36")) then
    return 70; -- Diners Club International
  elseif (string.starts(number, "54") or string.starts(number, "55")) then
    return 80; -- Diners Club
  elseif (string.starts(number, "637") or string.starts(number, "638") or string.starts(number, "639")) then
    return 100; -- InstaPayment
  elseif (string.starts(number, "35")) then
    return 110; -- JCB
  elseif (string.starts(number, "6304") or string.starts(number, "6706") or
    string.starts(number, "6771") or string.starts(number, "6709")) then
    return 120; -- Laser
  elseif (string.starts(number, "5018") or string.starts(number, "5020") or
    string.starts(number, "5038") or string.starts(number, "5893") or string.starts(number, "6304") or
    string.starts(number, "6759") or string.starts(number, "6761") or string.starts(number, "6762") or
    string.starts(number, "6763") or string.starts(number, "0604")) then
    return 130; -- Maestro
  elseif (string.starts(number, "6334") or string.starts(number, "6767")) then
    return 150; -- Solo
  else
    return 10; -- Invalid
  end
end

