class Generate

  def self.address(locale)
    if locale=="aus" then
      Faker::Config.locale = 'en-AU'
    else
      Faker::Config.locale = 'en-US'
    end

    street = Faker::Address.street_address
    city = Faker::Address.city
    state_code = Faker::Address.state_abbr
    zip = Faker::Address.zip

    #check for excluded states
    excludedStates = Fetch.exclude_states_setting.split(",")
    flag = false
    while !flag
      flag = true
      state = Faker::Address.state
      # Debug.log("Generated state: " + state)
      excludedStates.each do |ex|
        # Debug.log("Checking against excluded state: " + ex + ".")
        if state == ex.strip then
          flag = false
          Debug.log("Generated state is excluded. Generating new state.")
          break
        end
      end
    end

    return Hash["street" => street, "city" => city, "state" => state, "state_code" => state_code, "zip" => zip]
  end


  def self.birthday
    dob = Faker::Date.birthday(min_age: 21, max_age: 99)
    return Hash["month" => dob.strftime("%b"), "day" => dob.strftime("%-d"), "year" => dob.strftime("%Y")]
  end


  def self.cvv(type)
    if type.start_with?('American') then n=4 else n=3 end
    cvv = n.times.map { rand(0..9) }.join.to_s
  end


  def self.expiry_year
    return (Time.new.year + rand(1..5)).to_s
  end


  def self.random_day
    return Time.now - rand(31557600)
  end


  def self.creditcard
    #list of valid cards
    cc1 = Hash["type" => "American Express", "number" => "378282246310005"]
    cc2 = Hash["type" => "MasterCard", "number" => "5555555555554444"]
    cc3 = Hash["type" => "Visa", "number" => "4111111111111111"]
    cc4 = Hash["type" => "American Express", "number" => "371449635398431"]
    cc5 = Hash["type" => "American Express Corporate", "number" => "378734493671000"]
    cc6 = Hash["type" => "MasterCard", "number" => "5105105105105100"]
    cc7 = Hash["type" => "Visa", "number" => "4012888888881881"]
    cc8 = Hash["type" => "Visa", "number" => "4222222222222"]
    card = [cc1, cc2, cc3, cc4, cc5, cc6, cc7, cc8].sample

    return Hash["card" => card, "cvv" => cvv(card["type"]), "month" => random_day.strftime('%B'), "year" => expiry_year, "mo_num" => random_day.strftime('%m')]
  end


  def self.phone
    phone = 3.times.map{rand(1..9)}.join + "." + 3.times.map{rand(0..9)}.join + "." + 4.times.map{rand(0..9)}.join
  end


  def self.email
    timestamp = Time.new.inspect.gsub(/[ :-]/, '')[4..13]
    email =  Basic.setting("email_catcher") + "+" + timestamp + "@gmail.com"
  end


  def self.unique_customer(locale)
    fn = Faker::Name.unique.first_name
    ln = Faker::Name.unique.last_name
    return Hash["first" => fn, "last" => ln, "birthday" => birthday, "email" => email, "phone" => phone, "address" => address(locale), "card" => creditcard]
  end


  def self.inputdate(daysfromtoday)
    d = Date.today
    if daysfromtoday != 0 then d = d + daysfromtoday end
    d_str = d.strftime("%m") + "/" + d.strftime("%d") + "/" + d.strftime("%Y")
    # Debug.log ("generated date: " + d_str)
    return d_str
  end


  def self.nickname
    timestamp = Time.new.inspect.gsub(/[ :-]/, '')[4..13]
    randomNickname = "nickname" + "+" + timestamp
  end


  def self.product
    timestamp = Time.new.inspect.gsub(/[ :-]/, '')[4..13]
    randomProduct = "product" + timestamp
  end

end
