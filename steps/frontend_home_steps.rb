
class NavHome

  def nav_home
    System.fhome.load
    Verify.pageload(System.fhome, "Home")
  end

end
