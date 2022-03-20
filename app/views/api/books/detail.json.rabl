attributes :id, :name, :borrow_times, :repay_times, :price

node :price do |o|
  o.price.to_f
end