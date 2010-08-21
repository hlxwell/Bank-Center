class Bank::Transaction < ActiveRecord::Base
  CREDIT_TYPES = ["money", "job_credit", "ads_credit", "resume_download_credit"]
  set_table_name :bank_transactions

  default_scope :conditions => {:deleted_at => nil}
  scope :with_deleted, :conditions => "deleted_at IS NOT NULL"

  belongs_to :bank_account, :class_name => "Bank::Account", :foreign_key => "bank_account_id"

  def self.find_with_destroyed *args
    self.with_exclusive_scope { find(*args) }
  end

  def destroy
    self.update_attribute(:deleted_at, Time.now.utc)
  end
end