require File.dirname(__FILE__) + '/test_helper'

class BankCenterTest < ActiveSupport::TestCase
  load_schema

  test "schema has loaded correctly" do
    assert_not_equal nil, Bank::Transaction.all
    assert_not_equal nil, Bank::NegativeTransaction.all
    assert_not_equal nil, Bank::PositiveTransaction.all
    assert_not_equal nil, Bank::Account.all
  end  
end