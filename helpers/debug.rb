
class Debug

  def self.log(str)
    require 'colorize'
    if Basic.setting("debug")=="true" then puts ("DEBUG: " + str).white.on_blue end
  end

end
