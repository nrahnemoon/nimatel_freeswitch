Card = {}
Card.__index = Card;

function Card.init(pin, balance)
  local card = {};
  setmetatable(card, Card);
  card.pin = pin;
  card.balance = balance;
  return card;
end

