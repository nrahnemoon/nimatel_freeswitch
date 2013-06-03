local dbh = freeswitch.Dbh("pgsql://hostaddr=127.0.0.1 dbname=nimatel_production user=nimatel password=m0rt3l");
assert(dbh:connected());

session:answer();

digits = session:playAndGetDigits(12, 16, 1, 2000, "", "phrase:welcome_enter_pin_cc", "", "\\d+");

if string.len(digits) == 12 then
  dbh:query("SELECT * FROM cards WHERE pin='" .. digits .. "';", function(row)
    freeswitch.consoleLog("info", "\n\nbalance = " .. row.balance .. "\n\n");
  end);
  freeswitch.consoleLog("info", "\n12 digits " .. digits .. "\n");
elseif string.len(digits) == 16 then
  freeswitch.consoleLog("info", "16 digits " .. digits .. "\n");
else
  freeswitch.consoleLog("info", "Exit " .. digits .. "\n");
end

session:hangup();

