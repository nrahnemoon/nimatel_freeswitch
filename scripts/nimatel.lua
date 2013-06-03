local dbh = freeswitch.Dbh("pgsql://hostaddr=127.0.0.1 dbname=nimatel_production user=nimatel password=m0rt3l");
assert(dbh:connected());

session:answer();
session:sleep(400);

session:streamFile("nimatel/welcome.wav");
session:streamFile("nimatel/enter_pin_or_cc.wav");

session:hangup();

