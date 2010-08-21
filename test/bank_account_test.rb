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

  test "charge credit to account" do
    @account.charge(100)
    assert_equal 100, @account.remains
  end
end