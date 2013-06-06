require('nm-lib');
require('nm-db');
require('nm-ivr');

local db = Db.connect();
local ivr = Ivr.create(db);
ivr:start();

