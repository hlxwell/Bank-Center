class Bank::PositiveTransaction < Bank::Transaction
  validates_numericality_of :amount, :greater_than => 0
end