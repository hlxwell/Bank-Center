ActiveRecord::Schema.define(:version => 0) do
  create_table :transactions, :force => true do |t|
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
end