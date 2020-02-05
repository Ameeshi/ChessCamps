require 'test_helper'

class CreditCardTypeTest < ActiveSupport::TestCase
  ### TESTS NOT REQUIRED FOR PHASE 4
  def test_accessors
    assert CreditCardType.new("test", /^\d{4}$/).respond_to? :name
    assert CreditCardType.new("test", /^\d{4}$/).respond_to? :pattern
    deny CreditCardType.new("test", /^\d{4}$/).respond_to?(:name=)
    deny CreditCardType.new("test", /^\d{4}$/).respond_to?(:pattern=)
  end

  def test_match_works
    assert CreditCardType.new("test", /^\d{4}$/).match("1234")
    deny CreditCardType.new("test", /^\d{4}$/).match("12345")
    deny CreditCardType.new("test", /^\d{4}$/).match("123")
    deny CreditCardType.new("test", /^\d{4}$/).match("12-34")
  end
end