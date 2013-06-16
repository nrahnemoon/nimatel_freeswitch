require('nm-account')
require('nm-lib')
require('nm-wrate')

local dbDsn = "pgsql://hostaddr=127.0.0.1 dbname=nimatel_production user=nimatel password=m0rt3l";

Db = {};
Db.__index = Db;

function Db.connect()
  local db = {};
  setmetatable(db, Db);
  db.dbh = freeswitch.Dbh(dbDsn);
  if db.dbh:connected() == false then
    session:streamFile("phrase:nimatel_down_call_back_later");
    session:hangup();
    exit();
  end
  return db;
end

function Db:lookupAccount(num)
  local account;
  self.dbh:query("SELECT * FROM cards WHERE pin='" .. num .. "';",
    function(acct)
      if tableLength(acct) >= 1 then
        account = Account.init(acct.pin, acct.balance);
      else
        account = nil;
      end
    end);
  return account;
end

function Db:lookupRegion(num)
  local region;
  self.dbh:query("SELECT id FROM regions WHERE '"
      .. num .. "' LIKE prefix || '%' ORDER BY prefix DESC LIMIT 1;",
    function(loc)
      region = loc.id;
    end);
  return region;
end

function Db:lookupBestRate(num)
  local wrate;
  self:dbc:query("SELECT * FROM wholesaler_rates WHERE '" .. num ..
      "' LIKE prefix || '%' ORDER BY rate ASC LIMIT 1;",
    function(rate)
      wrate = WholesalerRate.init(rate.id, rate.rate, rate.billing_increment, rate.min_charge);
    end)
  return wrate;
end
  
