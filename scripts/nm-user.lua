User = {}
User.__index = User;

function User.init(email, cimProfileId, defaultPaymentProfileId)
  local user = {};
  setmetatable(user, User);
  user.email = email;
  user.cimProfileId = cimProfileId;
  user.defaultPaymentProfileId = defaultPaymentProfileId;
  user.cards = {};
  user.paymentProfiles = {};
  user.phoneNumbers = {};
  setmetatable(user.cards, {__index=table});
  setmetatable(user.paymentProfiles, {__index=table});
  setmetatable(user.phoneNumbers, {__index=table});
  return user;
end

function User:addCard(card)
  self.cards:insert(card);
end

function User:addPaymentProfile(paymentProfile) 
  self.paymentProfiles:insert(paymentProfile);
end

function User:addPhoneNumber(phoneNumber)
  self.phoneNumbers:insert(phoneNumber);
end

