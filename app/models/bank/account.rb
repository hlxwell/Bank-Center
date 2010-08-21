class Bank::Account < ActiveRecord::Base
  CREDIT_TYPES = ["money", "job_credit", "ads_credit", "resume_download_credit"]
  set_table_name "bank_accounts"

  validates_presence_of :name, :on => :create, :message => "can't be blank"
  validates_uniqueness_of :name, :on => :create, :message => "must be unique"

  has_many :bank_transactions, :class_name => "Bank::Transaction", :foreign_key => "bank_account_id"
  has_many :positive_bank_transactions, :class_name => "Bank::PositiveTransaction", :foreign_key => "bank_account_id"
  has_many :negative_bank_transactions, :class_name => "Bank::NegativeTransaction", :foreign_key => "bank_account_id"

  def remains(type = CREDIT_TYPES[0])
    bank_transactions.sum(:amount)
  end

  ### basic operations
  def charge amount
    ensure_positive_number(amount)
    positive_bank_transactions.create!(:amount => amount)
  end

  def pay amount
    ensure_positive_number(amount)
    negative_bank_transactions.create!(:amount => - amount)
  end

  def refund amount
    ensure_positive_number(amount)
    positive_bank_transactions.create!(:amount => amount)
  end

  def withdrawal amount
    ensure_positive_number(amount)
    negative_bank_transactions.create!(:amount => - amount)
  end

private

  def ensure_positive_number amount
    raise NegativeNumberError.new if amount <= 0
  end
end