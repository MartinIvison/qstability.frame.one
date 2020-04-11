require 'yaml'
require 'capybara'
require_relative '../helpers/basics.rb'
require_relative '../objects/system.rb'

class TestBasic < Test::Unit::TestCase

  def suite_list
    actual = Basic.suite_list
    assert_instance_of(Array, actual)
  end

  def test_suite_default
    precondition = ARGV.replace(Array.new)
    expected = "default"
    actual = Basic.suite
    assert_equal expected, actual
  end

  def test_suite_defined
    precondition = ARGV.replace(["default", "browserstack", "one", "2"])
    expected = "default"
    actual = Basic.suite
    assert_equal expected, actual
  end

  def test_mode_default
    precondition = ARGV.replace(Array.new)
    expected = "default"
    actual = Basic.mode
    assert_equal expected, actual
  end

  # def test_mode_defined
  #   precondition = ARGV.replace(["default", "browserstack", "one", "2"])
  #   expected = "browserstack"
  #   actual = Basic.mode
  #   assert_equal expected, actual
  # end

  def test_browserset_default
    precondition = ARGV.replace(Array.new)
    expected = ""
    actual = Basic.browserset
    assert_equal expected, actual
  end

  def test_browserset_defined
    precondition = ARGV.replace(["sandbox", "browserstack", "one", "2"])
    expected = "one"
    actual = Basic.browserset
    assert_equal expected, actual
  end

  def test_browsernumber_default
    precondition = ARGV.replace(Array.new)
    expected = ""
    actual = Basic.browsernumber
    assert_equal expected, actual
  end

  def test_browsernumber_defined
    precondition = ARGV.replace(["sandbox", "browserstack", "one", "2"])
    expected = "2"
    actual = Basic.browsernumber
    assert_equal expected, actual
  end

  def test_setting
    precondition = ARGV.replace(["", "unit-test"])
    expected = "false"
    actual = Basic.setting("debug")
    assert_equal expected, actual
  end

  def test_environment
    expected = "true"
    actual = Basic.environment("unit-test|value")
    assert_equal expected, actual
  end

  def test_secret
    expected = "true"
    actual = Basic.secret("unit-test|value")
    assert_equal expected, actual
  end

  #test_local_server omitted
  #test_define_browserstack_driver omitted

  def test_setup_setdriver
    precondition = Hash["os" => "local", "os_version" => " ", "browser" => " "]
    expected = :selenium
    actual = Basic.setup(precondition)
    assert_equal expected, actual
  end

  def test_beforetest_initializesystem
    precondition = Hash["os" => "local", "os_version" => " ", "browser" => " "]
    actual = Basic.before_test(precondition)
    assert_instance_of(System, actual)
  end

  #test_teardown omitted

  # def test_getbrowserlist_default
  #   expected = Array.new << Hash["os" => "OS X", "os_version" => "Sierra", "browser" => "Chrome"]
  #   actual = Basic.get_browserlist(nil, nil)
  #   assert_equal expected, actual
  # end

  # def test_getbrowserlist_one
  #   precondition = ARGV.replace(["default", "browserstack", "one", "1"])
  #   expected = Array.new << Hash["os" => "OS X", "os_version" => "Sierra", "browser" => "Chrome"]
  #   actual = Basic.get_browserlist("one", "1")
  #   assert_equal expected, actual
  # end

  # def test_getbrowserlist_random
  #   precondition = ARGV.replace(["default", "browserstack", "random", "2"])
  #   actual = Basic.get_browserlist("random", "1 2 4")
  #   assert_equal 1, actual.count
  # end

  # def test_getbrowserlist_select
  #   precondition = ARGV.replace(["default", "browserstack", "select", "1 4"])
  #   expected = Array.new << Hash["os" => "OS X", "os_version" => "Sierra", "browser" => "Chrome"] << Hash["os" => "Windows", "os_version" => "8", "browser" => "Firefox"]
  #   actual = Basic.get_browserlist("select", "1 4")
  #   assert_equal expected, actual
  # end

  # def test_getbrowserlist_all
  #   precondition = ARGV.replace(["default", "browserstack", "all"])
  #   actual = Basic.get_browserlist("all", nil)
  #   assert_equal 6, actual.count
  # end

  #test_runtest omitted

end
