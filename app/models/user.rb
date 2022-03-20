class User < ApplicationRecord

  validates :name, presence: true,
            length: {minimum: 2, maximum: 50, message: "Name length must be between 2 and 50"}
  validates :email, presence: true,
            uniqueness: {case_sensitive: false},
            format: {with: /\A[^@\s]+@([^@.\s]+\.)*[^@.\s]+\z/, message: "Email format error"}

  has_many :rental_records

  before_create :init_balance


  def locked_balance
    self.rental_records.where(kind: "borrow").sum(:price) - self.rental_records.where(kind: "repay").sum(:price)
  end

  def available_balance
    amount = self.balance - self.locked_balance
    amount > 0 ? amount : 0
  end

  def borrowing_count
    current_borrow_books.count
  end

  def current_borrow_books
    Book.borrowed_books.where(id: self.rental_records.borrow_records.pluck(:book_id))
  end

  private
    def init_balance
      self.balance = 1000
    end

end
