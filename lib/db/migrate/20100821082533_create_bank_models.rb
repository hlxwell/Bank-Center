class CreateBankModels < ActiveRecord::Migration
  def self.up
    create_table :bank_transactions, :force => true do |t|
      t.string      "type"
      t.integer     "bank_account_id"
      t.references  "related_object",   :polymorphic => true
      t.string      "credit_type"
      t.string      "from"
      t.string      "to"
      t.integer     "amount"
      t.string      "note"
      t.string      "cancel_reason"
      t.datetime    "cancelled_at"
      t.datetime    "deleted_at"
      t.timestamps
    end

    create_table :bank_accounts, :force => true do |t|
      t.references  "parent",           :polymorphic => true
      t.string      "name"
      t.timestamps
    end

    add_index :bank_accounts, [:parent_type, :parent_id]
    add_index :bank_transactions, :credit_type
    add_index :bank_transactions, :bank_account_id
    add_index :bank_transactions, [:related_object_type, :related_object_id]
  end

  def self.down
    drop_table :bank_transactions
  end
end
