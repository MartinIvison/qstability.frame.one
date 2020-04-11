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

class FLoginModal < SitePrism::Section
  element :username_input, "input[name='username']"
  element :password_input, "input[name='password']"
  element :login_bt, "button[type='submit'][value='submit'][class='defaultBtn']"
end

class FClubTeaser < SitePrism::Section
  element :club_title, "a[href*='/index.cfm?method=clubs.clubSignup']", match: :first
end

class FV2ClubTeaser < SitePrism::Section
  element :club_title, "a[href*='/index.cfm?method=clubsV2SignUp.login']", match: :first
end


# PAGE DEFINITIONS ==========================================

class FHome < SitePrism::Page
  #page url
  set_url ("http://" + Basic.frontend_url + "/")  #necessary for starting pages
  set_url_matcher /^(https?:\/\/#{Basic.frontend_url})/

  #page object definitions
  section :user_tools, FUserTools, "div[id='user-tools']"
  sections :product_items, FHomeProducts, "div[class='v65-productGroup-product']"
  section :login_modal, FLoginModal, "div[id='v65-modalContainer']"
  element :product_title, :xpath, "//*[@id='v65-modalCartTable']/tbody/tr[2]/td[3]/a/strong"
  element :wineclub_link, "a[href='/Wine-Club']", match: :first

  # validation on 'load'
  load_validation {[has_user_tools?(wait:60), 'cannot find user tools section']}
  load_validation {[has_product_items?(wait:60), 'cannot find product items']} #NOTE NEW
  load_validation {[has_wineclub_link?(wait:60), 'cannot find wineclub link']} #NOTE NEW - removed (wait:30) after ?
end


class FLoggedIn < SitePrism::Page
  #page url
  set_url_matcher /^(https?:\/\/#{Basic.frontend_url})(.)+/

  #page object definitions
  element :hello_user, "a[href*='memberEditAccount.editProfile']"

  # validation on 'load'
  load_validation {[has_hello_user?(wait:30), 'cannot find hello user']} #NOTE NEW
end


class FV2CheckoutLogin < SitePrism::Page
  #page url
  set_url_matcher /^(https?:\/\/#{Basic.frontend_url}\/.*\?method=checkoutV2.login)/

  #page object definitions
  element :guest_bt, "a[href*='checkoutAsGuest']"

  # validation on 'load'
  load_validation {[has_guest_bt?(wait:60), 'cannot find check-out-as-guest button']}
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


class FV2Checkout < SitePrism::Page
  #page url
  set_url_matcher /^(https?:\/\/#{Basic.frontend_url}\/.*\?method=checkoutV2.viewCheckout)/

  #page object definitions
  elements :products_in_cart, "a[href*='method=products.productDrilldown']"
  element :ship_birthmonth, "select[name='shipBirthMonth']"
  element :ship_birthday, "input[name='shipBirthDay']"
  element :ship_birthyear, "input[name='shipBirthYear']"
  element :ship_firstname, "input[name='shipFirstName']"
  element :ship_lastname, "input[name='shipLastName']"
  element :ship_phone, "input[name='shipMainPhone']"
  element :ship_email, "input[name='shipEmail']"
  element :ship_address, "input[name='shipAddress']"
  element :ship_city, "input[name='shipCity']"
  element :ship_state, "select[name='shipStateCode']"
  element :ship_zip, "input[name='shipZipCode']"
  element :ship_continue_bt, "button[v65js-click*='editShippingAddress']"

  # validation on 'load'
  load_validation {[has_products_in_cart?(wait:60), 'cannot find products in cart']} #NOTE NEW
  # load_validation {[has_ship_firstname?(wait:30), 'cannot find shipping first name input field']} #NOTE NEW
end


class FV2ShipAddress < SitePrism::Page
  #page url
  set_url_matcher /^(https?:\/\/#{Basic.frontend_url}\/.*\?method=checkoutV2.viewCheckout)/

  #page object definitions
  element :delivery_continue_bt, "button[class='button v65-continue'][v65js-click*='editShippingAddress']"

  # validation on 'load'
  load_validation {[has_delivery_continue_bt?(wait:30), 'cannot find delivery continue button']}
end


class FV2ShipOptions < SitePrism::Page
  #page url
  set_url_matcher /^(https?:\/\/#{Basic.frontend_url}\/.*\?method=checkoutV2.viewCheckout)/

  #page object definitions
  element :shipping_continue_bt, "button[class='button v65-continue'][v65js-click*='editShippingOptions']"

  # validation on 'load'
  load_validation {[has_shipping_continue_bt?(wait:30), 'cannot find shipping continue button']}
end


class FV2Payment < SitePrism::Page
  #page url
  set_url_matcher /^(https?:\/\/#{Basic.frontend_url}\/.*\?method=checkoutV2.viewCheckout)/

  #page object definitions
  element :cc_nameoncard, "input[name='nameOnCard']"
  element :cc_number, "input[name='cardNumber']"
  element :cc_month, "select[name='cardExpiryMo']"
  element :cc_year, "select[name='cardExpiryYr']"
  element :cc_cvv, "input[name='cvv2']"

  # validation on 'load'
  load_validation {[has_cc_nameoncard?(wait:30), 'cannot find card input fields']}
end


class FV2Billing < SitePrism::Page
  #page url
  set_url_matcher /^(https?:\/\/#{Basic.frontend_url}\/.*\?method=checkoutV2.viewCheckout)/

  #page object definitions
  element :use_ship_address, "input[type='checkbox'][id='copyShipping']"
  element :billing_continue_bt, "button[class='button v65-continue'][v65js-click*='editBillingAddress']"

  # validation on 'load'
  load_validation {[has_use_ship_address?(wait:30), 'cannot find use my shipping address checkbox']}
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


class FV2PlaceOrder < SitePrism::Page
  #page url
  set_url_matcher /^(https?:\/\/#{Basic.frontend_url}\/.*\?method=checkoutV2.viewCheckout)/

  #page object definitions
  element :place_order_bt, "button[class='v65-submit button v65-continue'][v65js-click*='editReviewOrder']"

  # validation on 'load'
  load_validation {[has_place_order_bt?(wait:60), 'cannot find order bt']}
end


class FV2Receipt < SitePrism::Page
  #page url
  set_url_matcher /^(https?:\/\/#{Basic.frontend_url}\/.*\?method=checkoutV2Review.viewReceipt.*)/

  #page object definitions
  element :order_detail, :xpath, "/html/body/div[1]/div/div/div[1]/div/p[1]"

  # validation on 'load'
  load_validation {[has_order_detail?(wait:90), 'cannot find order detail']}
end


class FClub < SitePrism::Page
  #page url
  set_url_matcher /^(https?:\/\/#{Basic.frontend_url}\/Wine-Club)/

  #page object definitions
  sections :club_teaser, FClubTeaser, "div[class='v65-club']"

  # validation on 'load'
  load_validation {[has_club_teaser?, 'cannot find club teaser']}
end


class FV2Club < SitePrism::Page
  #page url
  set_url_matcher /^(https?:\/\/#{Basic.frontend_url}\/Wine-Club)/

  #page object definitions
  sections :club_teaser, FV2ClubTeaser, "div[class='v65-club']"

  # validation on 'load'
  load_validation {[has_club_teaser?, 'cannot find club teaser']}
end


class FClubSignup < SitePrism::Page
  #page url
  set_url_matcher /^(https?:\/\/#{Basic.frontend_url}\/.*\?method=clubs.clubSignup.*)/

  #page object definitions
  elements :login_here, "a[href='/index.cfm?method=memberLogin.showLogin']"
  section :login_modal, FLoginModal, "div[id='v65-modalContainer']"

  # validation on 'load'
  load_validation {[has_login_here?, 'cannot find login link']}
end


class FV2ClubLogin < SitePrism::Page
  #page url
  set_url_matcher /^(https?:\/\/#{Basic.frontend_url}\/.*\?method=clubsV2SignUp.login)/

  #page object definitions
  element :guest_bt, "a[href*='/index.cfm?method=clubsV2SignUp.signUp']"

  # validation on 'load'
  load_validation {[has_guest_bt?(wait:30), 'cannot find guest button']} #NOTE NEW
end


class FV2ClubCheckout < SitePrism::Page
  #page url
  set_url_matcher /^(https?:\/\/#{Basic.frontend_url}\/.*\?method=clubsV2SignUp.signUp)/

  #page object definitions
  element :ship_birthmonth, "select[name='shipBirthMonth']"
  element :ship_birthday, "input[name='shipBirthDay']"
  element :ship_birthyear, "input[name='shipBirthYear']"
  element :ship_firstname, "input[name='shipFirstName']"
  element :ship_lastname, "input[name='shipLastName']"
  element :ship_phone, "input[name='shipMainPhone']"
  element :ship_email, "input[name='shipEmail']"
  element :ship_address, "input[name='shipAddress']"
  element :ship_city, "input[name='shipCity']"
  element :ship_state, "select[name='shipStateCode']"
  element :ship_zip, "input[name='shipZipCode']"
  # element :ship_continue_bt, "button[v65js-click*='editShippingAddress']"
  element :delivery_continue_bt, "button[class='button v65-continue'][v65js-click*='editClubShippingAddress']"

  # validation on 'load'
  load_validation {[has_ship_firstname?(wait:60), 'cannot find shipping first name input field']}
end


class FV2ClubPayment < SitePrism::Page
  #page url
  set_url_matcher /^(https?:\/\/#{Basic.frontend_url}\/.*\?method=clubsV2SignUp.signUp)/

  #page object definitions
  element :cc_nameoncard, "input[name='nameOnCard']"
  element :cc_number, "input[name='cardNumber']"
  element :cc_month, "select[name='cardExpiryMo']"
  element :cc_year, "select[name='cardExpiryYr']"
  element :cc_cvv, "input[name='cvv2']"
  element :billing_continue_bt, "button[class='button v65-continue'][v65js-click*='editClubBillingAddress']"

  # validation on 'load'
  load_validation {[has_cc_nameoncard?(wait:60), 'cannot find card input fields']}
end


class FClubBilling < SitePrism::Page
  #page url
  set_url_matcher /^(https?:\/\/#{Basic.frontend_url}\/.*\?method=clubs.clubSignup.*)/

  #page object definitions
  element :continue_button, "button[type='submit'][value='submit'][class='largeBtn']"
  element :bill_birthmonth, "select[name='BirthMonth']"
  element :bill_birthday, "select[name='BirthDay']"
  element :bill_birthyear, "select[name='BirthYear']"
  element :bill_firstname, "input[name='FirstName']"
  element :bill_lastname, "input[name='LastName']"
  element :bill_phone, "input[name='MainPhone']"
  element :bill_email, "input[name='Email']"
  element :bill_address, "input[name='Address']"
  element :bill_city, "input[name='City']"
  element :bill_state, "select[name='StateCode']"
  element :bill_zip, "input[name='ZipCode']"
  element :username, "input[name='Username']"
  element :password, "input[name='Password']"
  element :confirm_password, "input[name='ConfirmPassword']"
  element :cc_nameoncard, "input[name='NameOnCard']"
  element :cc_number, "input[name='cardNumber']"
  element :cc_month, "select[name='cardExpiryMo']"
  element :cc_year, "select[name='cardExpiryYr']"
  element :cc_cvv, "input[name='CVV2']"
  element :shipping_option, "select[name='shipTo']"
end


class FClubBilling2 < SitePrism::Page
  #page url
  set_url_matcher /^(https?:\/\/#{Basic.frontend_url}\/.*\?method=clubs.clubSignup.*)/

  #page object definitions
  element :continue_button, "button[type='submit'][value='submit'][class='largeBtn']"
  element :shipping_option, "select[name='shipTo']"

  # validation on 'load'
  load_validation {[has_shipping_option?(wait:90), 'cannot find shipping option']}
end


class FV2ClubAccount < SitePrism::Page
  #page url
  set_url_matcher /^(https?:\/\/#{Basic.frontend_url}\/.*\?method=clubsV2SignUp.signUp)/

  #page object definitions
  element :password, "input[name='password']"
  element :confirm_password, "input[name='confirmPassword']"
  element :account_continue_bt, "button[class='button v65-continue'][v65js-click*='editClubLoginDetails']"

  # validation on 'load'
  load_validation {[has_password?(wait:90), 'cannot find password field']}
end


class FClubReview < SitePrism::Page
  #page url
  set_url_matcher /^(https?:\/\/#{Basic.frontend_url}\/.*\method=clubs.review.*)/

  #page object definitions
  elements :club_order_button, "button[type='submit'][class='largeBtn']"

  # validation on 'load'
  load_validation {[has_club_order_button?(wait:90), 'cannot find club order button']}
end


class FV2ClubSubscribe < SitePrism::Page
  #page url
  set_url_matcher /^(https?:\/\/#{Basic.frontend_url}\/.*\?method=clubsV2SignUp.signUp)/

  #page object definitions
  element :subscribe_club_bt, "button[class='v65-submit button v65-continue'][v65js-click*='editReviewClub']"

  # validation on 'load'
  load_validation {[has_subscribe_club_bt?(wait:90), 'cannot find subscribe button']}
end


class FV2ClubReceipt < SitePrism::Page
  #page url
  set_url_matcher /^(https?:\/\/#{Basic.frontend_url}\/.*\method=clubsV2Review.viewReceipt.*)/

  #page object definitions
  element :membership_detail, :xpath, "/html/body/div[1]/div/div/p[1]"

  # validation on 'load'
  load_validation {[has_membership_detail?(wait:90), 'cannot find membership detail']}
end



class FClubReceipt < SitePrism::Page
  #page url
  set_url_matcher /^(https?:\/\/#{Basic.frontend_url}\/.*\?method=clubs.receipt)/

  #page object definitions
  elements :headings, "strong"
  element :home_link, "a[href='/'][accesskey = 'h']"

  # validation on 'load'
  load_validation {[has_headings?(wait:90), 'cannot find headings']}
  load_validation {[has_home_link?(wait:90), 'cannot find home link']}
end


class FLogoutHome < SitePrism::Page
  #page url: alternative definition of Home with a different URL, which appears after logout
  set_url_matcher /^(https?:\/\/#{Basic.frontend_url}\/.*\?method=homepage.showPage)/

  #page object definitions
  element :login_link, "a[href*='method=memberLogin.showLogin'][referrerquerystring='method=homepage.showPage']"

  # validation on 'load'
  load_validation {[has_login_link?(wait:30), 'cannot find login link']}
end
