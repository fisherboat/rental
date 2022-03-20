class RentalRecord < ApplicationRecord
  extend Enumerize

  belongs_to :book
  belongs_to :user

  counter_culture :book, column_name: proc {|model| "#{model.kind}_times" }

  enumerize :kind, in: [:borrow, :repay]

  scope :borrow_records, -> {where(kind: "borrow")}
  scope :repay_records, -> {where(kind: "repay")}

  validates :book, :user, presence: true

  validate :valid_book_invertory, if: -> { self.kind.borrow? }
  validate :valid_user_balance, if: -> { self.kind.borrow? }

  validate :valid_book_repay, if: -> { self.kind.repay? }

  def run_borrow
    self.book.with_lock do
      self.save!
    end
  end

  def run_repay
    self.book.with_lock do
      user.balance -= self.price
      user.save!
      self.save!
    end
  end

  private
    def valid_book_invertory
      self.book.reload
      unless self.book.can_borrow?
        self.errors.add(:book_id, "Book has been borrowed")
      end

    end

    def valid_user_balance
      if self.user.available_balance < self.price
        self.errors.add(:user_id, "User not have enough balance.")
      end
    end

    def valid_book_repay
      self.book.reload
      unless self.book.can_repay?(self.user_id)
        self.errors.add(:book_id, "Book cannot be replied")
      end
    end

end
