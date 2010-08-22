class Bank::Transaction < ActiveRecord::Base
  set_table_name :bank_transactions

  include EnumerateIt
  has_enumeration_for :credit_type, :with => CreditType, :create_helpers => true

  default_scope where(:deleted_at => nil)
  scope :with_deleted, where("deleted_at IS NOT NULL")
  scope :without_cancelled, where(:cancelled_at => nil)

  belongs_to :bank_account, :class_name => "Bank::Account", :foreign_key => "bank_account_id"
  belongs_to :related_object, :polymorphic => true

  def cancel!(reason = nil)
    raise NoCancelReasonError.new if reason.blank?
    update_attributes :cancel_reason => reason, :cancelled_at => Time.now
  end

  def cancelled?
    cancelled_at.present?
  end

  def destroy
    update_attribute(:deleted_at, Time.now)
  end
end