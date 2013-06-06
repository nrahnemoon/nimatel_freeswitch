require('nm-account')
require('nm-lib')

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

