require File.dirname(__FILE__) + '/test_helper'

class BankTransactionTest < ActiveSupport::TestCase
  load_schema

  def setup
    @account = Bank::Account.create(:name => "test")
    @transaction = @account.charge!(100)
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

  test "should be able to list all deleted transactions" do
    @transaction.destroy
    assert_nil Bank::Transaction.with_deleted.find_by_id(@transaction.id)
  end

  test "should use the init state 'waiting'" do
    assert_equal 'waiting', @transaction.state
  end

  test "should be able to 'accept' and 'cancel'" do
    @transaction.cancel
    assert_equal 'cancelled', @transaction.state
  end

  test "should be able to accept" do
    @transaction.accept
    assert_equal 'done', @transaction.state
    assert_not_nil @transaction.done_at
  end

end