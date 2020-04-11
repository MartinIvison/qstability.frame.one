
class Suite

  def run_suite
    puts "SUITE: default"

    #include scenario code
    require_relative "../scenarios/frontend_scenarios"

    #scenarios to run
    FrontendScenario.new.guest_order
  end

end
