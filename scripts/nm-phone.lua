Phone = {}
Phone.__index = Phone;

function Phone.init(number, remember, userId)
  local phone = {};
  setmetatable(phone, Phone);
  phone.number = number;
  phone.remember = remember;
  phone.userId = userId;
  return phone;
end


