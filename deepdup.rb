def deepdup(array)
  return array unless array.is_a?(Array)
  
  array.map do |sub|
    sub = deepdup(sub)
  end
end

a = [1,[2, [3, 4]]]  
b = deepdup(a)

b << 5

p a, b

b = a

b << 5

p a, b