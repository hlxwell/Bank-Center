class Bank::Transaction < ActiveRecord::Base
  set_table_name :bank_transactions

  include EnumerateIt
  has_enumeration_for :credit_type, :with => CreditType, :create_helpers => true

  default_scope where(:deleted_at => nil)
  scope :with_deleted, where("deleted_at IS NOT NULL")

  belongs_to :bank_account, :class_name => "Bank::Account", :foreign_key => "bank_account_id"
  belongs_to :related_object, :polymorphic => true

  state_machine :initial => 'waiting' do
    event :accept do
      transition :from => 'waiting', :to => 'done'
    end

    event :cancel do
      transition :from => 'waiting', :to => 'cancelled'
    end

    after_transition :to => 'done' do |transition|
      transition.touch :done_at
    end
  end

  def destroy
    self.update_attribute(:deleted_at, Time.now.utc)
  end
end