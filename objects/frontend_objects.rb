# SITE: FRONTEND ===========================================
# all classes start with 'F' for frontend

class AnyPage < SitePrism::Page
end


# COMMON SECTIONS ==========================================

class FUserTools < SitePrism::Section
  element :checkout_bt, "a[href*='/index.cfm?method=checkout']"
  element :login_link, "a[href*='method=memberLogin.showLogin'][referrerquerystring='']"
  element :logout_link, "a[href='/index.cfm?method=memberlogin.processLogout']"
end

class FHomeProducts < SitePrism::Section
  element :addtocart_bt, "button[type='submit'][value='submit'][class='defaultBtn']"
  element :product_title, "a[href*='/product/'][itemprop='name']"
end



# PAGE DEFINITIONS ==========================================

class FHome < SitePrism::Page
  #page url
  set_url ("http://" + Basic.frontend_url + "/")  #necessary for starting pages
  set_url_matcher /^(https?:\/\/#{Basic.frontend_url})/

  #page object definitions
  section :user_tools, FUserTools, "div[id='user-tools']"
  sections :product_items, FHomeProducts, "div[class='v65-productGroup-product']"
  element :product_title, :xpath, "//*[@id='v65-modalCartTable']/tbody/tr[2]/td[3]/a/strong"

  # validation on 'load'
  load_validation {[has_user_tools?(wait:60), 'cannot find user tools section']}
  load_validation {[has_product_items?(wait:60), 'cannot find product items']}
end


class FBilling < SitePrism::Page
  #page url
  set_url_matcher /^(https?:\/\/#{Basic.frontend_url}\/.*\?method=checkout.billing)/

  #page object definitions
  elements :products_in_cart, :xpath, "//*[@id='v65-checkoutCartSummaryMini']/table/tbody/tr/td"
  element :bill_birthmonth, "select[name='BillBirthMonth']"
  element :bill_birthday, "select[name='BillBirthDay']"
  element :bill_birthyear, "select[name='BillBirthYear']"
  element :bill_firstname, "input[name='BillFirstName']"
  element :bill_lastname, "input[name='BillLastName']"
  element :bill_phone, "input[name='BillMainPhone']"
  element :bill_email, "input[name='BillEmail']"
  element :bill_address, "input[name='BillAddress']"
  element :bill_city, "input[name='BillCity']"
  element :bill_state, "select[name='BillStateCode']"
  element :bill_zip, "input[name='BillZipCode']"
  element :cc_nameoncard, "input[name='nameOnCard']"
  element :cc_number, "input[name='CardNumber']"
  element :cc_month, "select[name='CardExpiryMo']"
  element :cc_year, "select[name='CardExpiryYr']"
  element :cc_cvv, "input[name='CVV2']"
  element :continue_bt, :xpath, "//*[@id='v65-continueOrder']/button"

  # validation on 'load'
  load_validation {[has_cc_nameoncard?, 'cannot find name on card input field']}
  load_validation {[has_cc_number?, 'cannot find name on card input field']}
  load_validation {[has_cc_month?, 'cannot find name on expiry month dropdown']}
  load_validation {[has_cc_year?, 'cannot find name on expiry year dropdown']}
  load_validation {[has_continue_bt?, 'cannot find continue & review button']}
  load_validation {[has_products_in_cart?(wait:60), 'cannot find products in cart']}
end


class FReview < SitePrism::Page
  #page url
  set_url_matcher /^(https?:\/\/#{Basic.frontend_url}\/.*\?method=checkout.review)/

  #page object definitions
  element :place_order_bt, "button[type='submit'][data-text='Processing...Please Wait']", match: :first

  # validation on 'load'
  load_validation {[has_place_order_bt?, 'cannot find place order button']}
end


class FReceipt < SitePrism::Page
  #page url
  set_url_matcher /^(https?:\/\/#{Basic.frontend_url}\/.*\?method=checkout.receipt)/

  #page object definitions
  element :order_detail, :xpath, "/html/body/article/div/p[2]"
  element :order_link, :xpath, "/html/body/article/div/p[2]/a[1]"

  # validation on 'load'
  load_validation {[has_order_link?(wait:90), 'cannot find order link']}
  load_validation {[has_order_detail?(wait:90), 'cannot find order detail']}
end
