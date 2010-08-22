require File.dirname(__FILE__) + '/test_helper'

class BankAccountTest < ActiveSupport::TestCase
  load_schema

  def setup
    @account = Bank::Account.create(:name => "test")
    @account.charge!(100)
    @account.charge!(1, :credit_type => CreditType::JOB)
  end

  def teardown
    @account.destroy
  end

  test "account name should be unique" do
    assert_equal false, Bank::Account.new(:name => "test").save
  end

  test "charge money to account" do
    assert_equal 100, @account.remains
  end

  test "charge job credit to account" do
    assert_equal 1, @account.remains(CreditType::JOB)
  end

  test "pay money" do
    @account.pay!(23, :credit_type => CreditType::MONEY, :from => "account", :to => "serviceA", :related_object => @account) ### related_object
    assert_equal 77, @account.remains(CreditType::MONEY)
  end

  test "should not pay money when no remained money in account" do
    assert_raise(::CreditNotEnoughError) do
      @account.pay!(101, :credit_type => CreditType::MONEY, :from => "account", :to => "serviceA", :related_object => @account) ### related_object
    end
  end
end