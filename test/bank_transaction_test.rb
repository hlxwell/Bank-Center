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

  test "should be able to 'cancel'" do
    assert_raise(NoCancelReasonError) do
      @transaction.cancel!
    end

    @transaction.cancel!("not received money.")
    assert_not_nil @transaction.cancelled_at
  end

end