function tableLength(T)
  local count = 0;
  for _ in pairs(T) do count = count + 1; end
  return count
end

function string.starts(main, prefix)
   return string.sub(main, 1, string.len(prefix)) == prefix
end

