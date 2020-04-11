#ERROR-HANDLING UTILITIES

class DoException

  def self.critical(error)
    msg = " Critical error: aborting test"
    if Fetch.color_setting then puts msg.red else puts msg end
    if Basic.setting("browser_mode") !="browserstack"
      Capybara.screenshot_and_save_page
    end
    Basic.after_test(error)
    Basic.teardown
    exit
  end


  def self.noncritical
    msg = " Non-critical error: continuing test"
    if Fetch.color_setting then puts msg.red else puts msg end
      if Basic.setting("browser_mode") !="browserstack"
        Capybara.screenshot_and_save_page
      end
  end


  def self.on_fail
    if Basic.setting("error_on_fail")=="true" and $result < 0 then
      raise Exception, "Overall test failed.", ""
    end
  end


  def self.terminate(msg) #aborting before test starts
    puts msg
    exit
  end

end
