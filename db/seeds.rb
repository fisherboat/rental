# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# threads = 40.times.map do
#   Thread.new do
#     620000.times {  Book.create!(name: Faker::Lorem.sentence(word_count: 3, supplemental: false, random_words_to_add: 4), price: rand(1..100)) }
#   end
# end
# threads.map(&:join)
# $start_id = 1194649

# def insert_data(i)
#   1000.times do |j|
#     id = $start_id + i + j
#     ActiveRecord::Base.connection.execute "insert into books \
#     (id, name, price, updated_at, created_at) \
#     values \
#     (#{id}, '#{Faker::Lorem.sentence(word_count: 3, supplemental: false, random_words_to_add: 4)}', #{rand(1..100)}}, '#{Time.now.to_s[0,9]}', '#{Time.now.to_s[0,9]}')"
#   end
# end

# 1000.times do |i|
#   ActiveRecord::Base.transaction { insert_data(i * 1000) }
# end

1000.times do
  Book.create!(name: Faker::Lorem.sentence(word_count: 3, supplemental: false, random_words_to_add: 4), price: rand(1..100), stock: rand(1..20))
end


