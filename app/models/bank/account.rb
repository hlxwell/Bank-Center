class Bank::Account < ActiveRecord::Base
  set_table_name "bank_accounts"

  validates_presence_of :name, :on => :create, :message => "can't be blank"
  validates_uniqueness_of :name, :on => :create, :message => "must be unique"

  has_many :transactions, :class_name => "Bank::Transaction", :foreign_key => "bank_account_id", :order => "created_at ASC"
  has_many :positive_transactions, :class_name => "Bank::PositiveTransaction", :foreign_key => "bank_account_id"
  has_many :negative_transactions, :class_name => "Bank::NegativeTransaction", :foreign_key => "bank_account_id"

  def remains(type = CreditType::MONEY)
    transactions.without_cancelled.where(:credit_type => type).sum(:amount)
  end

  ### basic operations
  ["charge", "pay", "refund", "withdraw"].each do |operation|
    class_eval <<-EOF
      def #{operation}! amount, option = {}
        ensure_positive_number(amount)
        operate_credit!(amount, "#{operation}", option)
      end
    EOF
  end

private

  def operate_credit! amount, operation, option
    option[:credit_type] ||= CreditType::MONEY

    case operation
    when "charge", "refund"
      positive_transactions.create! option.merge(:amount => amount, :to => "account")
    when "pay", "withdrawal"
      raise CreditNotEnoughError.new if remains(option[:credit_type]) < amount.abs
      negative_transactions.create! option.merge(:amount => - amount, :from => "account")
    else
      raise "unknown operation"
    end
  end

  def ensure_positive_number amount
    raise NegativeNumberError.new if amount <= 0
  end
end