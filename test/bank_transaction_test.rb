require File.dirname(__FILE__) + '/test_helper'

class BankTransactionTest < ActiveSupport::TestCase
  load_schema

  def setup
    @account = Bank::Account.create(:name => "test")
    @transaction = @account.charge(100)
  end

  def teardown
    @account.destroy
  end

  test "should mark deleted_at after destroy" do
    @transaction.destroy
    assert_not_nil @transaction.deleted_at
  end

  test "should not be listed after destroy" do
    @transaction.destroy
    assert_nil Bank::Transaction.find_by_id(@transaction.id)
  end

  # test "charge money to account" do
  #   @account.charge(100)
  #   assert_equal 100, @account.remains
  # end
  #
  # test "charge job credit to account" do
  #   @account.charge(1, "job_credit")
  #   assert_equal 1, @account.remains("job_credit")
  # end
end