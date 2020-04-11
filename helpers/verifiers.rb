# OBJECT VERIFIERS

class Verify

  def self.pageload(pageobj, name)
    # Debug.log("checking that " + name + " page loads")
    check_page = false
    if (pageobj.displayed? & pageobj.loaded?) then check_page = true end
    # Debug.log("Displayed: " + pageobj.displayed?.to_s)
    # Debug.log("Loaded: " + pageobj.loaded?.to_s)
    # Debug.log("Check Page: " + check_page.to_s)
    Report.verdict(name + " page loads", check_page, pageobj.load_error)
    if !check_page then DoException.critical(pageobj.load_error) end
    return check_page
  end


  def self.itempresence(collection, match, att, msg, reverse)
    #checks collection of page object elements for presence of match(ing string)
    v = nil
    collection.each_with_index do |obj, i|
      case att
      when "text"
        basket = obj.text
      when "value"
        basket = obj.value
      when "href"
        basket = obj[:href]
      end

      Debug.log("Verify.itempresence - looking for match of " + match + " in " + basket)
      if basket.include? match then
        v = i  #return index
        break
      end
    end

    #reverse logic when checking for item NOT there
    if reverse then
      if v==nil then v=0 else v=nil end
      Debug.log("Verify.itempresence reversing result")
    end

    #report and return
    Debug.log("Verify.itempresence - returning index: " + v.to_s)
    Report.verdict(msg, v, nil)
    return v
  end


  def self.tagtext(obj, match, msg)
    #checks single element for presence of text
    foundit = nil
    if visible(obj, "Text object", true)
      Debug.log("Text to search: " + obj.text)
      Debug.log("Looking for: " + match)
      if obj.text.include? match then foundit = obj.text end
    end
    Report.verdict(msg, foundit, nil)
    return foundit
  end


  def self.many_visible(page_obj, element_as_str, name, mandatory)
    isgood = true
    begin
      #parse out base element and hierarchy
      obj = page_obj
      parse_str = element_as_str.split(".")
      b = parse_str.last
      parse_str.delete(b)
      a = parse_str.join(".")
      if a.length>0 then a << "." end

      #assemble command string and execute (this is necessary, because SitePrism's element collections do not respond to the visible? method)
      cmd_str = "obj." + a + "wait_until_" + b + "_visible"
      eval(cmd_str)

    #catch load errors
  rescue Capybara::Poltergeist::ObsoleteNode, SitePrism::TimeOutWaitingForElementVisibility, Capybara::Poltergeist::TimeoutError, Selenium::WebDriver::Error::UnknownError, Selenium::WebDriver::Error::StaleElementReferenceError => error
      isgood = false
    end

    #record pass/fail
    if mandatory then Report.verdict(name + " found", isgood, error.inspect) end
    if error and mandatory then DoException.critical(error.inspect) end
    return isgood
  end


  def self.visible(obj, name, mandatory)
    # Debug.log("Checking for visibility: " + name)
    isgood = true
    begin
      obj.visible?
    rescue Capybara::Poltergeist::ObsoleteNode, SitePrism::TimeOutWaitingForElementVisibility, Capybara::ElementNotFound, Capybara::Poltergeist::TimeoutError, Selenium::WebDriver::Error::UnknownError, Selenium::WebDriver::Error::StaleElementReferenceError => error
      isgood = false
    end

    #record pass/fail
    if mandatory then Report.verdict(name + " found", isgood, error.inspect) end
    if error and mandatory then DoException.critical(error.inspect) end
    return isgood
  end


  def self.equal_number(a, b, msg, tries)
    isgood = false
    while tries > 0 do
      Debug.log("Number Check Countdown - Try:" + tries.to_s + " - Comparing expected=" + a.to_s + " to actual=" + b.to_s )
      tries -= 1
      Action.pause
      if a == b then
        isgood = true
        break
      end
    end
    if isgood == false then DoException.noncritical end
    Report.verdict(msg, isgood, nil)
  end


  def self.equal_text(a, b, msg)
    isgood = true
    if a != b
      isgood = false
      Debug.log("Comparing:" + a + " and " + b + " are not equal" )
      DoException.noncritical
    end
    Report.verdict(msg, isgood, nil)
  end

end
