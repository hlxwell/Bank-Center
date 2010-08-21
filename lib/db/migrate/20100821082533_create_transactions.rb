class CreateTransactions < ActiveRecord::Migration
  def self.up
    create_table :transactions do |t|
      t.string      "type"
      t.references  "parent", :polymorphic => true
      t.references  "related_object", :polymorphic => true
      t.string      "credit_type"
      t.string      "credit_from"
      t.string      "credit_to"
      t.integer     "amount"
      t.string      "state"
      t.string      "note"
      t.datetime    "done_at"
      t.datetime    "deleted_at"
      t.timestamps
    end

    add_index :transactions, :credit_type
    add_index :transactions, [:parent_type, :parent_id]
    add_index :transactions, [:related_object_type, :related_object_id]
  end

  def self.down
    drop_table :transactions
  end
end
