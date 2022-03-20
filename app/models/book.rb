class Book < ApplicationRecord

  validates :name, presence: true
  has_many :rental_records

  scope :borrowed_books, -> {where("borrow_times > repay_times")}

  def can_borrow?
    self.remaining_stock > 0
  end

  def remaining_stock
    self.stock - self.borrow_times + self.repay_times
  end

  def can_repay?(user_id)
    flag = self.borrow_times > self.repay_times
    return false unless flag
    borrow_book_times = self.rental_records.borrow_records.where(user_id: user_id).count
    borrow_repay_times = self.rental_records.repay_records.where(user_id: user_id).count
    if borrow_book_times <= borrow_repay_times
      flag = false
    end
    return flag
  end

end
