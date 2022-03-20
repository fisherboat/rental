object @user
attributes :id, :name, :email, :balance

node :balance do |o|
  o.balance.to_f
end

child @user.current_borrow_books do
  attributes :id, :name, :price
end