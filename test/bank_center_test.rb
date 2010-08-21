require File.dirname(__FILE__) + '/test_helper'

class BankCenterTest < ActiveSupport::TestCase
  load_schema

  test "schema has loaded correctly" do
    assert_equal [], Bank::Transaction.all
  end
end