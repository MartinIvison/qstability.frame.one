
# ==========================
#  SAMPLE OBJECT DEFINITIONS
# ==========================

# matching on a substring with '*='
element :next_bt, "a[onclick*='next']"

# looking for one attribute, but NOT another, with ':not'
element :finish_bt, "a[onclick*='next']:not([class*='Tender'])"

# picking the first element that matches the definition
element :club_title, "a[href*='/index.cfm?method=clubs.clubSignup']", match: :first

# matching with xpath, when there is no suitable css identifier
element :order, :xpath, "//*[@id='popupContent']/table[1]/tbody/tr[2]/td[1]"

# defining objects that occur multiple times on the same page (e.g. various links that all have the same href target)
elements :x_bt, "a[href*='QuickDelete']"

# defining sections, which are objects that contain further objects (e.g. a nav-bar)
# 1. define the section object on the page:
section :nav_bar, SNavBar, "nav[class='v65-main-navigation']"
# 2. define the section object as a separate class, but above the page
class SNavBar < SitePrism::Section
  element :store_bt, "a[href*='store']"
end

# defining iframes, which are a page within a pages
# 1. define the iframe object on the page
iframe :store_iframe, SStoreIframe, "#Wrapper"
# 2. define the iframe object as a separate class, but above the page
class SStoreIframe < SitePrism::Page
  iframe :body_iframe, SBodyIframe, "#BodyFrame"  # note that iframes can be nested
  element :products_link, "a[href='/2014/store/index.cfm?method=products.list']"
end



# ======================
#  SAMPLE STEP COMMANDS
# =======================

# Wait before next command (adds robustness when needed)
Action.pause

# Enter a new URL in the browser
System.fhome.load

# Verify that a new page has loaded
Verify.pageload(System.fclubreceipt, "ClubReceipt")  #arguments in brackets are: page object, page name for reporting

# Click a button or link (simple method, without checking for visibility or error handling)
System.plogin.submit_bt.click

# Click a button or link (safe method, with checking for visibility and error handling)
Action.safeclick(System.ppin.login_bt, "Login Button")  #arguments in brackets are: click object, object name for reporting

# Hover over an object (e.g. a menu to see additional menu items)
frame.club_link.hover

# Set an input field value (simple method, without checking for visibility or error handling)
System.scontactadd.firstname.set "Peter"

# Set an input field value (safe method, with checking for visibility and error handling)
Action.safeinput(System.scontactview.firstname, "First Name field", "Peter") #arguments in brackets are: field object, object name for reporting, value to set

# Select a value from a dropdown list
System.scontactadd.country.select "United States"

# Click 'ENTER' keyboard command, for modals where clicking 'ENTER' will trigger the add/close action.
System.sclubselectproduct.qty_input.native.send_keys(:return)

# Print an informational line to the console
Report.info("Text")

# Print a Pass/Fail verdict to the console
Report.verdict("Add Order popup displayed", System.sstore.has_popup_iframe?, nil) #arguments in brackets are: object name for reporting, condition evaluating to true or false, an additional argument usually not needed (for passing an error; this is usually 'nil')

# Print debug information to the console, which only appears if Debug mode is set to true in Settings
Debug.log('text')



# ==========================
#  SPECIALIZED STEP COMMANDS
# ==========================

# Click a button on a confirmation alert
System.scontactview.accept_alert do  #note that accept_alert is not an object, but a page method which allows access to the objects on the alert
  Action.safeclick(System.scontactview.delete_bt, "Delete button")   #note that this button is defined on the main page
end

# Interact with an iFrame
# Note that due to capybara internals it is necessary to pass a block to the iframe instead of simply calling methods on it, or its child objects;
System.sstore.store_iframe do |frame|
  Action.safeclick(frame.add_order_bt, "Add Order button")
end

# Nested iframes
System.sstore.store_iframe do |frame|
  frame.body_iframe do |subframe|
      Action.safeclick(subframe.add_order_bt, "Add Order button")
  end
end

# Verify that an object is visible. Note, safeclick and safeinput already contain this, so it is only necessary for single objects that are neither clicked nor used for input. For object collections, use many_visible below.
Verify.visible(System.plogin.submit_bt, "Submit button", true)

# Verify that an object collection is visible
Verify.many_visible(System.fclub, "club_teaser", "Club Teaser Section", true)  # arguments in brackets are: page, collection object, collection object name for reporting, and whether visibility is mandatory (if set to nil, no error is thrown)

# Verify that a text string is present between the tags of a single object (e.g. <p class='object'>text</p>)
Verify.tagtext(System.freceipt.order_detail, 'Order Number:', "Order number appears")  #arguments in brackets are: object, search text, object name for reporting

# Verify that a text string is present in a collection of object instances (e.g. search results)
# Arguments in brackets are: collection to search, search string, searchable object attribute (can be value, text or href), and an additional argument that when true returns true when a string is not present (e.g. for no search results)
Verify.itempresence(System.scontactresults.checkbox, @cid, "value", "Contact ID in Search Results", nil)
Verify.itempresence(System.fbilling.products_in_cart, product_title, "text", product_title + " is in cart", nil)  # searches the text between opening and closing tags of the object (e.g. <p class='object'>text</p>)
Verify.itempresence(System.scontactresults.edit_link, @cid, "href", "Contact ID in Edit Links", nil)
Verify.itempresence(System.scontactresults.checkbox, @cid, "value", "No search results for deleted Contact ID", true)   # Verify that a text string is NOT present in a collection of object instances

# Pick a random object from an object collection (e.g. a random search result)
random_club = System.fclub.club_teaser.sample

# Fetch a setting from the Settings file
Fetch.age_setting
Fetch.cvv_setting
Fetch.pin_setting
Fetch.fixed_customer["user"]
Fetch.admin_password

# Get a GUID from the end of URL
Fetch.id_from_url(System.scontactview)  # argument in brackets is the page object which has the URL we're checking

#Determine current URL
url = Capybara.page.driver.browser.current_url

# Load a URL directly
Capybara.page.driver.visit(url)
