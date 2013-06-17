require('nm-card')
require('nm-lib')
require('nm-phone')
require('nm-user')
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

function Db:getCardByPin(pin)
  local card;
  self.dbh:query("SELECT * FROM cards WHERE pin='" .. pin .. "';",
    function(c)
      if tableLength(c) >= 1 then
        card = Card.init(c.pin, c.balance);
      else
        card = nil;
      end
    end);
  return card;
end

function Db:getRegionByPrefix(prefix)
  local region;
  self.dbh:query("SELECT id FROM regions WHERE '"
      .. prefix .. "' LIKE prefix || '%' ORDER BY prefix DESC LIMIT 1;",
    function(r)
      region = r.id;
    end);
  return region;
end

function Db:getBestRateByPrefix(prefix)
  local rate;
  self.dbc:query("SELECT * FROM wholesaler_rates WHERE '" .. prefix ..
      "' LIKE prefix || '%' ORDER BY rate ASC LIMIT 1;",
    function(r)
      rate = WholesalerRate.init(r.id, r.rate, r.billing_increment, r.min_charge);
    end);
  return rate;
end

function Db:getUserByNumber(number)
  local user;
  self.dbc:query("SELECT User.id, User.email, User.cim_profile_id, User.defaultPaymentProfileId, PhoneNumber.number, PhoneNumber.remember" ..
    " FROM phone_numbers JOIN users ON phone_number.user_id = user.id WHERE PhoneNumber.number='" .. number .. "';",
    function(u)
      user = User.init(u.email, u.cim_profile_id, u.default_payment_profile_id);
      user.addPhoneNumber(Phone.init(u.number, u.remember, u.id));
      return user;
    end);
end

