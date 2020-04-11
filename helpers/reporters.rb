#REPORTING UTILITIES

class Report

  def self.title(msg)
    msg = "\nSCENARIO: " + msg
    if Fetch.color_setting then puts msg.light_blue else puts msg end
  end


  def self.browser_under_test(browser)
    if (browser["os"]) then os = browser["os"] else os = "" end
    if (browser["device"]) then device = browser["device"] else device = "" end
    if (browser["browser"]) then br = browser["browser"] else br = "" end
    puts "BROWSER: " + device + " " + os  + " " + browser["os_version"]  + " " + br
  end


  def self.session_id
    puts "SESSION ID: " + Capybara.page.driver.browser.session_id
  end


  def self.description(msg)
    puts "Test description: " + msg
  end


  def self.preconditions(msg)
    puts "Preconditions: " + msg
  end


  def self.info(msg)
    puts " Info: " + msg
  end


  def self.problem(msg)
    msg = " Problem encountered: " + msg
    if Fetch.color_setting then puts msg.yellow else puts msg end
  end


  def self.verdict(item, verd, error)
    if verd then
      msg = (" " + item + ": PASS")
      if Fetch.color_setting then puts msg.green else puts msg end
      if $result > -1 then $result+=1 end #add overall pass only if no fail recorded
    else !verd
      if error then msg=(" " + item + ": FAIL - " + error) else msg=(" " + item + ": FAIL") end
      if Fetch.color_setting then puts msg.red else puts msg end
      $result = -1 #record overall fail
    end
  end


  def self.results
    puts "================================"
    if $result>-1 then
      msg = (" OVERALL RESULT: PASS (" + $result.to_s + " validations)")
      if Fetch.color_setting then puts msg.green else puts msg end
    else
      msg =" OVERALL RESULT: FAIL"
      if Fetch.color_setting then puts msg.red else puts msg end
    end
    puts " Run time: " + (Time.now - $run_time).round(2).to_s + "s"
    puts "================================"
  end


  def self.result_to_browserstack(error)
    require 'net/http'
    require 'uri'
    require 'json'

    uri_str = "https://api.browserstack.com/automate/sessions/" + Capybara.page.driver.browser.session_id + ".json"
    uri = URI.parse(uri_str)
    # Debug.log("BS API call URI string: " + uri_str)
    request = Net::HTTP::Put.new(uri)
    request.basic_auth(Basic.secret("Browserstack|user"), Basic.secret("Browserstack|key"))
    request.content_type = "application/json"
    req_options = { use_ssl: uri.scheme == "https" }

    if $result>-1 then
      request.body = JSON.dump({ "status" => "passed" })
    else
      request.body = JSON.dump({ "status" => "failed", "reason" => error })
    end

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
  end

end
