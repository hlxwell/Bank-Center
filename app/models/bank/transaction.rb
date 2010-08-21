class Bank::Transaction < ActiveRecord::Base
  set_table_name :bank_transactions

  belongs_to :bank_account, :class_name => "Bank::Account", :foreign_key => "bank_account_id"
end