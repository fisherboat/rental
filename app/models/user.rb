class User < ApplicationRecord

  validates :name, presence: true,
            length: {minimum: 2, maximum: 10, message: "Name length must be between 2 and 10"}
  validates :email, presence: true,
            uniqueness: {case_sensitive: false},
            format: {with: /\A[^@\s]+@([^@.\s]+\.)*[^@.\s]+\z/, message: "Email format error"}

  has_many :rental_records

  before_create :init_balance


  def locked_balance
    self.rental_records.where(kind: "borrow").sum(:price) - self.rental_records.where(kind: "return").sum(:price)
  end

  def available_balance
    amount = self.balance - self.locked_balance
    amount > 0 ? amount : 0
  end

  def current_borrow_books
    Book.borrowed_books.where(id: self.rental_records.borrow_records.pluck(:book_id))
  end

  private
    def init_balance
      self.balance = 1000
    end

end
