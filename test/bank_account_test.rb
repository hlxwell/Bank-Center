require File.dirname(__FILE__) + '/test_helper'

class BankAccountTest < ActiveSupport::TestCase
  load_schema

  def setup
    @account = Bank::Account.create(:name => "test")
  end

  def teardown
    @account.destroy
  end

  test "account name should be unique" do
    assert_equal false, Bank::Account.new(:name => "test").save
  end

  test "charge money to account" do
    @account.charge(100)
    assert_equal 100, @account.remains
  end
  
  test "charge job credit to account" do
    @account.charge(1, "job_credit")
    assert_equal 1, @account.remains("job_credit")
  end
end