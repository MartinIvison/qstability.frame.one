class Fetch

  def self.age_setting
    age_setting = Basic.environment(Basic.setting("environment") + "|verify_age")
  end

  def self.cvv_setting
    cvv_setting = Basic.environment(Basic.setting("environment") + "|use_cvv")
  end

  def self.exclude_states_setting
    excluded_setting = Basic.environment(Basic.setting("environment") + "|excluded_states")
  end

  def self.color_setting
    if Basic.setting("colored_output")=="true" then return true else return false end
  end

  def self.id_from_url(page)
    id = page.current_url.rpartition('=').last
  end

end
