require 'faker'
require_relative '../helpers/generators.rb'
require_relative '../helpers/data_handlers.rb'
require_relative '../helpers/debug.rb'

class TestVerify < Test::Unit::TestCase

  def test_address
    actual = Generate.address("aus")
    assert_instance_of(Hash, actual)
    assert_equal 5, actual.count
    assert actual["street"]
    assert actual["city"]
    assert actual["state"]
    assert actual["state_code"]
    assert actual["zip"]
  end

  def test_birthday
    actual = Generate.birthday
    assert_instance_of(Hash, actual)
    assert_equal 3, actual.count
    assert actual["month"]
    assert actual["day"]
    assert actual["year"]
  end

  def test_cvv_amex
    precondition = "American"
    expected = /^\d{4}$/
    actual = Generate.cvv(precondition)
    assert_match expected, actual
  end

  def test_cvv_other
    precondition = ""
    expected = /^\d{3}$/
    actual = Generate.cvv(precondition)
    assert_match expected, actual
  end

  def test_expiryyear
    expected = /^20\d{2}$/
    actual = Generate.expiry_year
    assert_match expected, actual
  end

  def test_randomday
    actual = Generate.random_day
    assert_instance_of Time, actual
  end

  def test_creditcard
    actual = Generate.creditcard
    assert_instance_of Hash, actual
    assert_instance_of Hash, actual["card"]
    assert_equal 5, actual.count
  end

  def test_phone
    actual = Generate.phone
    assert_equal 12, actual.length
  end

  def test_email
    expected = /^.*\+\d*@gmail.com$/
    actual = Generate.email
    assert_match expected, actual
  end

  def test_uniquecustomer
    actual = Generate.unique_customer("us")
    assert_instance_of(Hash, actual)
    assert_equal 7, actual.count
    assert actual["first"]
    assert actual["last"]
  end

  def test_inputdate_today
    expected = Date.today.strftime("%m") + "/" + Date.today.strftime("%d") + "/" + Date.today.strftime("%Y")
    actual = Generate.inputdate(0)
    assert_equal 10, actual.length
    assert_equal expected, actual
  end

  def test_nickname
    expected = /^nickname.*/
    actual = Generate.nickname
    assert_match expected, actual
  end

end
