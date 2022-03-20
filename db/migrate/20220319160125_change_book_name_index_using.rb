class ChangeBookNameIndexUsing < ActiveRecord::Migration[7.1]
  def up
    remove_index :books, :name
    ActiveRecord::Base.connection.execute "CREATE EXTENSION pg_trgm;CREATE INDEX index_books_on_name ON books USING gin (name gin_trgm_ops);"
  end

  def down
    remove_index :books, :name
    add_index :books, :name
  end
end
