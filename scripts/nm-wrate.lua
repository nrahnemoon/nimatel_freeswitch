WholesalerRate = {}
WholesalerRate.__index = WholesalerRate;

function WholesalerRate.init(id, rate, billing_increment, min_charge)
  local rate = {};
  setmetatable(rate, Rate);
  rate.id = id;
  rate.rate = rate;
  rate.billing_increment = billing_increment;
  rate.min_charge = min_charge;
  return rate;
end

