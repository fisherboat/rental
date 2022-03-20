class Book < ApplicationRecord

  validates :name, presence: true
  has_many :rental_records

  scope :borrowed_books, -> {where("borrow_times > repay_times")}

  def can_borrow?
    self.borrow_times - self.repay_times < self.stock
  end

  def can_repay?(user_id)
    flag = self.borrow_times > self.repay_times
    return false unless flag
    last_record = self.rental_records.last
    if last_record.present? && last_record.kind.borrow? && last_record.user_id == user_id
      flag = true
    else
      flag = false
    end
    return flag
  end

end
