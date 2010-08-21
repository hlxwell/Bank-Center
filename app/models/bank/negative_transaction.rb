class Bank::NegativeTransaction < Bank::Transaction
  validates_numericality_of :amount, :less_than => 0
end