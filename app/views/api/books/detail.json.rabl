attributes :id, :name, :borrow_times, :repay_times, :stock, :price, :remaining_stock

node :price do |o|
  o.price.to_f
end