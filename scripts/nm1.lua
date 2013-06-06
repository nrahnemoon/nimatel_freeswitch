function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

local dbh = freeswitch.Dbh("pgsql://hostaddr=127.0.0.1 dbname=nimatel_production user=nimatel password=m0rt3l");
assert(dbh:connected());

session:answer();

local payAttempt = 0;
local payValid = false;
local accountInfo = {};
local digits;
while (payValid ~= true and ccAttempt < 3) do 
  if ccAttempt == 0 then
    digits = session:playAndGetDigits(12, , 1, 2000, "", "phrase:welcome_enter_pin_cc", "", "\\d+");
  else
    digits = session:playAndGetDigits(12, 16, 1, 2000, "", "phrase:invalid_pin_try_again", "", "\\d+");
  end

  if string.len(digits) == 12 then
    dbh:query("SELECT * FROM cards WHERE pin='" .. digits .. "';", function(row)
      freeswitch.consoleLog("info", "\n\nbalance = " .. row.balance .. "\n\n");
      accountInfo = row;
    end);
    if tablelength(accountInfo) >= 1 then
      payValid = true;
    end
  elseif string.len(digits) == 16 then
    freeswitch.consoleLog("info", "16 digits " .. digits .. "\n");
  else
    freeswitch.consoleLog("info", "Exit " .. digits .. "\n");
  end
end

session:hangup();

