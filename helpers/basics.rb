# BASIC TESTING UTILITIES

class Basic

  # =======================================
  # CLI argument handlers
  # =======================================

  def self.suite_list
    files = Dir["suites/*"]
    suites = Array.new
    files.each { |item| suites << item[7..(item.index('_suite'))-1] }
    return suites
  end


  def self.suite
    flag = 0
    if ARGV.length>0 then
      suite_list.each { |suite| if (ARGV[0] == suite) then flag = 1 end }
      if flag == 1 then
        suite=ARGV[0]
      else
        DoException.terminate("ERROR: The specified test suite does not exist. Valid suites are: " + suite_list.join(", "))
      end
    else
      suite="default"
    end
  end


  def self.mode
    flag = 0
    if ARGV.length>1 then
      valids = read_yaml("settings/settings.yaml").keys
      valids.each { |item|
        if (ARGV[1] == item) then flag = 1 end
        }
      if flag == 1 then
        return ARGV[1]
      else
        DoException.terminate("ERROR: The specified setting mode does not exist. Valid modes are: " + valids.join(", "))
      end
    else
      return "default"
    end
  end


  def self.browserset
    env=""
    if ARGV.length>2 then
      flag = 0
      valid = ["one", "random", "all", "select"]
      valid.each { |item| if item == ARGV[2] then flag = 1 end }
      if flag == 1 then
        env=ARGV[2]
      else
        puts "WARNING: browserset '" + ARGV[2] + "' is invalid. Valid values are: one, random, select, all. Proceeding with defaults."
      end
    end
    return env
  end


  def self.browsernumber
    no_of_browsers = read_yaml("settings/browsers.yaml").length
    if (ARGV.length>3 && (ARGV[3].to_i <= no_of_browsers)) then
      num=ARGV[3]
    else
      if (ARGV[2] == "one" || ARGV[2] == "select") then
        puts "WARNING: browser number '" + ARGV[3].to_s + "' is invalid. Valid values are 1 -" + no_of_browsers.to_s + ". Proceeding with defaults."
      end
      num=""
    end
  end


  # =======================================
  # YAML file readers
  # =======================================

  def self.read_yaml(str)
    begin
      file = YAML.load_file(str)
    rescue => error
      DoException.terminate("YAML file " + str + " seems to be broken. Error: " + error.inspect)
    end
  end


  def self.setting(str)
    file = read_yaml("settings/settings.yaml")[mode]
    value = file[str].to_s
  end


  def self.environment(str)
    level = str.split("|")
    file = read_yaml("settings/environments.yaml")[level[0]]
    value = file[level[1]].to_s
    return value
  end


  def self.frontend_url
    base_url = environment(setting("environment") + "|frontend_url")
  end


  def self.secret(str)
    level = str.split("|")
    file = read_yaml("settings/accounts.yaml")[level[0]]
    value = file[level[1]].to_s
    return value
  end


  # =======================================
  # Driver setup
  # =======================================

  def self.local_server(cmd, key)  #START/STOP BROWSERSTACK SERVER
    server = BrowserStack::Local.new
    case cmd
    when "start"
      runtime_args = {"key" => key}
      if server.nil? then server.start(runtime_args) end
    when "stop"
      if !server.nil? then server.stop end
    end
  end


  def self.define_browserstack_driver(br_hash)
    #set capabilities
    connect_str = "http://" + secret("Browserstack|user") + ":" + secret("Browserstack|key") + "@hub-cloud.browserstack.com/wd/hub"
    caps = Selenium::WebDriver::Remote::Capabilities.new
    caps['os'] = br_hash['os']
    caps['os_version'] = br_hash['os_version']
    caps['browser'] = br_hash['browser']
    caps['browser_version'] = br_hash['browser_version']
    caps['device'] = br_hash['device']
    caps['real_mobile'] = br_hash['real_mobile']
    caps['deviceOrientation'] = br_hash['device_orientation']
    caps["browserstack.debug"] = "true"
    caps["browserstack.networkLogs"] = "true"
    caps['acceptSslCerts'] = 'true'
    caps['ie.ensureCleanSession'] = 'true'
    caps['nativeEvents'] = "true"
    caps['javascriptEnabled'] = "true"
    caps['cssSelectorsEnabled'] = "true"
    caps['project'] = setting("project")

    #start-up local server
    local_server("start", secret("Browserstack|key"))

    #define unique driver name by joining os, version and browser
    driver_name = br_hash.values.join.gsub(/\s+/, "")

    #register driver
    Capybara.register_driver driver_name do |app|
      @driver = Capybara::Selenium::Driver.new(app, :browser => :remote, :url => connect_str, :desired_capabilities => caps)
    end
    if $result>1 then
      Capybara.current_driver = driver_name  #on subsequent passes
    else
      Capybara.default_driver = driver_name #on first pass
    end

    #print session ID
    Report.session_id
  end


  def self.setup(br_hash)  #SETUP RUN BEFORE ALL TESTS
    #additional required gems
    # require 'colorize'
    require 'faker'
    require 'capybara-screenshot'
    require 'browserstack/local'
    require 'selenium/webdriver'
    require 'capybara/poltergeist'

    # counter for overall result
    $result = 0
    $run_time = Time.now

    #set driver
    puts "\nMODE: " + setting("browser_mode")
    puts "ENVIRONMENT: " + setting("environment")
    case setting("browser_mode")
    when "browserstack"
      define_browserstack_driver(br_hash)
    when "safari"
      Capybara.register_driver(:selenium) { |app| @driver = Capybara::Selenium::Driver.new(app, :browser => :safari) }
      Capybara.default_driver = :selenium
      Capybara.page.driver.browser.manage.window.maximize
    when "headless"  #Phantomjs
      Capybara.register_driver(:poltergeist) { |app| @driver = Capybara::Poltergeist::Driver.new(app, js_errors: false) }
      Capybara.default_driver = :poltergeist
    when "firefox"
      Capybara.register_driver(:selenium) { |app| @driver = Capybara::Selenium::Driver.new(app) }
      Capybara.default_driver = :selenium
    when "headless-chrome"
      Capybara.register_driver :selenium do |app|
        @driver = Capybara::Selenium::Driver.new app, browser: :chrome, options: Selenium::WebDriver::Chrome::Options.new(args: %w[headless disable-gpu])
      end
      Capybara.default_driver = :selenium
    else  #default: chrome
      Capybara.register_driver(:selenium) { |app| @driver = Capybara::Selenium::Driver.new(app, :browser => :chrome) }
      Capybara.default_driver = :selenium
    end
    Capybara.run_server = false

    #settings for object mgmt
    Capybara.exact = false
    Capybara.default_max_wait_time = setting("time_out").to_i

    #settings for capturing screenshots
    Capybara.save_path = "tmp"  #for screenshots
    Capybara::Screenshot.prune_strategy = :keep_last_run

    return Capybara.default_driver
  end


  def self.before_test(br_hash)  #RUN BEFORE INDIVIDUAL TEST
    #switch driver when testing on multiple browsers in browserstack
    if setting("browser_mode")=="browserstack" and $result>1 then
      @driver.quit
      define_browserstack_driver(br_hash)
    end

    #initialize system under test
    System.new
  end


  def self.after_test(error)  #RUN AFTER INDIVIDUAL TEST
    if setting("browser_mode")=="browserstack" then
      Report.result_to_browserstack(error)
    end
  end


  def self.teardown  #RUN AFTER ALL TESTS
    sleep setting("wait_before_close").to_i
    Report.results

    #stop local browserstack server, if running
    local_server("stop", nil)

    #throw error if overall result is Fail
    DoException.on_fail
  end


  def self.get_browserlist(env, num)
    # get supported browsers
    browsers = read_yaml("settings/browsers.yaml")
    br_array = Array.new << browsers[0]  #default is to run on first browser

    #build environment array
    n = num.to_i
    if setting("browser_mode")=="browserstack" then
      case env
      when "one"
        if n.between?(1,browsers.count) then
          br_array[0] = browsers[num.to_i-1]
        end
      when "random"
        tmp = Array.new
        if num.respond_to?(:split) then
          numbers = num.split
          if (num == "") then numbers = ('1'..(browsers.count.to_s)).to_a end #if empty
          # Debug.log("Number: " + numbers.join(', '))
          numbers.each do |br|
            if br.to_i.between?(1,browsers.count) then tmp << browsers[br.to_i-1] end
          end
          br_array = Array.new
          br_array << tmp.sample
        end
      when "select" #RUN ON LIST OF BROWSERS
        if num.respond_to?(:split) then
          tmp = Array.new
          numbers = num.split
          numbers.each do |br|
            if br.to_i.between?(1,browsers.count) then tmp << browsers[br.to_i-1] end
          end
          if tmp.count>0 then br_array = tmp end
        end
      when "all"  #RUN ON ALL DEFINED BROWSERS
          br_array = browsers
      end
    else
      br_array = Array.new << Hash["os" => "local", "os_version" => " ", "browser" => " ", "browser_version" => " ", "device" => " ", "real_mobile" => " ", "deviceOrientation" => " "]
    end

    # Debug.log("BrowserArray read-out:" + br_array.join(', '))
    return br_array
  end


  # =======================================
  # Running the test
  # =======================================

  def self.run_test(browser)
    Report.browser_under_test(browser)
    before_test(browser)
    Suite.new.run_suite
    after_test("")
  end

end
