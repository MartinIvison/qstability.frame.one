
class OrderProduct

  def add_product
    Debug.log("Step: OrderProduct.add_product")

    #select any product on page
    random_product = System.fhome.product_items.sample
    Action.safeclick(random_product.addtocart_bt, "Add-to-cart button")

    #verify product is in cart and store to check cart again on checkout
    if Verify.visible(System.fhome.product_title, "Product in cart", nil) then
      if !@product then @product = Array.new end
      @product.push(random_product.product_title.text)
      Report.info("product selected: " + random_product.product_title.text)
    end
    Action.pause
  end


  def checkout
    Debug.log("Step: OrderProduct.checkout")

    Verify.pageload(System.fhome, "Home")
    Action.pause
    Action.safeclick(System.fhome.user_tools.checkout_bt, "Checkout button")
  end


  def verify_cart
    Debug.log("Step: OrderProduct.verify_cart")

    #verify each product is in cart
    Verify.pageload(System.fbilling, "Checkout: Billing")
  end


  def generate_customer
    Debug.log("Step: OrderProduct.generate_customer")

    @customer = Generate.unique_customer("us")
  end


  def store_customer
    Debug.log("Step: OrderProduct.store_customer")

    @address = @customer["address"]
    @card = @customer["card"]
    @birthday = @customer["birthday"]

    # record customer info in report
    infostr = "Customer: " + @customer["first"] + " " + @customer["last"] + ". DOB: " + @birthday["month"] + " " + @birthday["day"] + ", " + @birthday["year"]
    infostr << ". Email: " + @customer["email"] + ", PH:" + @customer["phone"] + ", " + @address["street"] + ", " + @address["city"]
    infostr << ", " + @address["state"] + ", " + @address["zip"]
    Report.info(infostr)
  end


  # def get_customer
  #   Debug.log("Step: OrderProduct.get_customer")
  #
  #   @customer = Fetch.fixed_customer
  #   @card = Generate.creditcard
  # end


  def enter_billing
    Debug.log("Step: OrderProduct.enter_billing")

    #fill in date of birth, if required in site settings (settings.rb)
    if Fetch.age_setting == "true" then
      System.fbilling.bill_birthmonth.select @birthday["month"]
      System.fbilling.bill_birthday.select @birthday["day"]
      System.fbilling.bill_birthyear.select @birthday["year"]
    end

    #fill in billing name and address
    System.fbilling.bill_firstname.set @customer["first"]
    System.fbilling.bill_lastname.set @customer["last"]
    System.fbilling.bill_phone.set @customer["phone"]
    System.fbilling.bill_email.set @customer["email"]
    System.fbilling.bill_address.set @address["street"]
    System.fbilling.bill_city.set @address["city"]
    System.fbilling.bill_zip.set @address["zip"]
    System.fbilling.bill_state.select @address["state"]
  end


  def enter_payment
    Debug.log("Step: OrderProduct.enter_payment")
    #report cc
    infostr = "Credit card: " + @customer["first"] + " " + @customer["last"]
    infostr << ", " + @card["card"]["type"] + " " + @card["card"]["number"] + ", Exp: " + @card["month"] + " " + @card["year"]

    #fill in credit card
    System.fbilling.cc_nameoncard.set (@customer["first"] + " " + @customer["last"])
    System.fbilling.cc_number.set @card["card"]["number"]
    System.fbilling.cc_month.select @card["month"]
    System.fbilling.cc_year.select @card["year"]

    #fill in CVV2 field, if required in site settings
    if Fetch.cvv_setting == "true" then
      System.fbilling.cc_cvv.set @card["cvv"]
      infostr << ", CVV:" + @card["cvv"]
    end
    Report.info(infostr)  #record cc info in report
  end


  def review_order
    Debug.log("Step: OrderProduct.review_order")

    Action.pause
    Action.safeclick(System.fbilling.continue_bt, "Continue button")
    Verify.pageload(System.freview, "Checkout: Review")
  end


  def place_order
    Debug.log("Step: OrderProduct.place_order")

    # System.freview.place_order_bt.click
    Action.safeclick(System.freview.place_order_bt, "Place Order button")
    Verify.pageload(System.freceipt, "Checkout: Receipt")
    Verify.tagtext(System.freceipt.order_detail, 'Order Number:', "Order number appears")
    Report.info("Order #:" + System.freceipt.order_link.text)
  end

end
