# add necessary objects and steps
require_relative "../objects/frontend_objects"
require_relative "../steps/frontend_home_steps"
require_relative "../steps/frontend_order_steps"


class FrontendScenario

  def guest_order
    Report.title("guest customer orders product (base-2)")
    Report.description("the simplest way for a customer to order a product, as a guest, without separate shipping address, using all defaults")
    Report.preconditions("base-2 checkout; products have no inventory or shipping limitations")

    #Steps which describe the scenario
    step = NavHome.new
    step.nav_home
    step = OrderProduct.new
    step.add_product
    step.checkout
    step.verify_cart
    step.generate_customer
    step.store_customer
    step.enter_billing
    step.enter_payment
    step.review_order
    step.place_order
  end

end
