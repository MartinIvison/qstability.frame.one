# DRIVER SCRIPT
# run-time arguments: test.rb "suite" "settings" "bs mode" "bs number(s)"
# Examples:
# ruby test.rb  - without arguments, runs default suite with default settings (settings.yaml)
# ruby test.rb "sandbox"  - runs sandbox suite with default settings
# ruby test.rb "default" "jenkins"  - runs default suite with jenkins settings
# ruby test.rb "default" "browserstack"  - browserstack without arguments runs on the first browser in the list (browsers.yaml)
# ruby test.rb "default" "browserstack" "all"  - runs on all defined browsers
# ruby test.rb "default" "browserstack" "one" "2"  - runs on browser 2 in the list
# ruby test.rb "default" "browserstack" "select" "2 3 4"  - runs on browsers 2,3,4
# ruby test.rb "default" "browserstack" "random" " 1 2 6"  - runs on a random browsers form the list specified in the argument


# include gems and helpers
require 'capybara'
require 'site_prism'
require 'yaml'
require 'colorize'
require_relative "helpers/basics"
require_relative "helpers/generators"
require_relative "helpers/data_handlers"
require_relative "helpers/error_handlers"
require_relative "helpers/verifiers"
require_relative "helpers/reporters"
require_relative "helpers/actions"
require_relative "helpers/debug"
require_relative "objects/system"
require_relative "suites/" + Basic.suite + "_suite"


# define run sequence
def testrun
  begin
    browsers = Basic.get_browserlist(Basic.browserset, Basic.browsernumber)
    Basic.setup(browsers[0])

    browsers.each do |onbrowser|
      Basic.run_test(onbrowser)
    end

    Basic.teardown

  rescue => error
    Debug.log("Exception caught at test.rb level")
    $result = -1
    Basic.after_test(error)
    Basic.teardown
  end
end


# execute
testrun do
end
