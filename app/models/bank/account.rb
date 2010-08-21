class Bank::Account < ActiveRecord::Base
  set_table_name "bank_accounts"

  validates_presence_of :name, :on => :create, :message => "can't be blank"
  validates_uniqueness_of :name, :on => :create, :message => "must be unique"

  has_many :bank_transactions, :class_name => "Bank::Transaction", :foreign_key => "bank_account_id"
  has_many :positive_bank_transactions, :class_name => "Bank::PositiveTransaction", :foreign_key => "bank_account_id"
  has_many :negative_bank_transactions, :class_name => "Bank::NegativeTransaction", :foreign_key => "bank_account_id"

  def remains(type = Bank::Transaction::CREDIT_TYPES.first)
    bank_transactions.sum(:amount, :conditions => { :credit_type => type })
  end

  ### basic operations
  ["charge", "pay", "refund", "withdrawal"].each do |operation|
    class_eval <<-EOF
      def #{operation} amount, type = Bank::Transaction::CREDIT_TYPES.first
        ensure_positive_number amount
        operate_credit amount, "#{operation}", type
      end
    EOF
  end

private

  def operate_credit amount, operation, type
    case operation
    when "charge", "refund"
      positive_bank_transactions.create!(:amount => amount, :credit_type => type)
    when "pay", "withdrawal"
      negative_bank_transactions.create!(:amount => - amount, :credit_type => type)
    else
      raise "unknown operation"
    end
  end

  def ensure_positive_number amount
    raise NegativeNumberError.new if amount <= 0
  end
end