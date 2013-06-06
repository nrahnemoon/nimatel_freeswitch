require('nm-lib')
require('nm-account')

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
  dbh:query("SELECT * FROM cards WHERE pin='" .. digits .. "';",
    function(acct)
      if tableLength(acct) >= 1 then
        account = Account.init(acct.pin, acct.balance);
        return account;
      else
        return nil;
      end
    end);
end

