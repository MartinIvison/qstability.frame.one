# REPEATED ACTIONS

class Action

  def self.hide_intercom
    System.anypage.execute_script("window.Intercom('shutdown');")
    # System.anypage.execute_script("window.pendo.stopGuides();")
  end


  def self.open_popup(page_obj, element_obj, name)
    #returns pop-up window object
    isgood = true
    begin
      if Verify.visible(element_obj, name, true) then
        @popup = page_obj.window_opened_by do
          safeclick(element_obj, name)
        end
      else
        isgood = false
      end
    rescue => error
      isgood = false
    end

    if isgood == false then
      Report.verdict("Open pop-up", isgood, error.inspect)
      DoException.critical(error.inspect)
    end
    return @popup
  end


  def self.pause
    sleep Basic.setting("slow_down").to_i
  end


  def self.scroll_to(obj)
    System.anypage.execute_script("arguments[0].scrollIntoView(true);", obj)
  end


  def self.scroll_to_top
    System.anypage.execute_script("window.scrollTo(0,0);")
  end


  def self.safeclick(obj, name)
    # Debug.log('Safe click: ' + name)
    isgood = true
    begin
      if Verify.visible(obj, name, true) then
        scroll_to(obj)
        obj.click
      else
        isgood = false
      end
    rescue => error
      isgood = false
    end

    if isgood == false then
      Report.verdict(name + " responds to click", isgood, error.inspect)
      DoException.critical(error.inspect)
    end
    return isgood
  end


  def self.safeinput(obj, name, value)
    # Debug.log('Safe input: ' + name)
    isgood = true
    begin
      if Verify.visible(obj, name, true) then
        scroll_to(obj)
        obj.set value
      else
        isgood = false
      end
    rescue => error
      isgood = false
    end

    if isgood == false then
      Report.verdict(name + " responds to input", isgood, error.inspect)
      DoException.critical(error.inspect)
    end
    return isgood
  end

end
