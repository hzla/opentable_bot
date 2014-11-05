class OpentableTools 
	@@base_reserve_url = "https://m.opentable.com/reservation/details?"
	attr_accessor :restaurant_id, :date_time, :party_size, :first_name, :last_name, :email, :phone_number, :r_details, :browser, :confirmation_id

	def initialize options=nil
		options = {restaurant_id: 105223, date_time: "11/13/2014 21:30:00", party_size: 2, first_name: "Robert", last_name: "Gustavez", email: "neohzla@gmail.com", phone_number: "4157760400"} if !options
		@restaurant_id = options[:restaurant_id]
		@date_time = URI.encode(options[:date_time]).gsub('/','%2F').gsub(':','%3A') #11/04/2014 16:00 in local time
		@party_size = options[:party_size]
		@first_name = options[:first_name]
		@last_name = options[:last_name]
		@email = options[:email]
		@confirmation_id
		@phone_number = options[:phone_number] || "9499813668"
		@r_details = "RestaurantID=#{restaurant_id}&Points=100&SecurityID=0&DateTime=#{date_time}&PartySize=#{party_size}&OfferConfirmNumber=0&ChosenOfferId=0&IsMiddleSlot=False&ArePopPoints=False"
	end

	def reserve
		browser = Watir::Browser.new :phantomjs
		browser.goto(@@base_reserve_url + r_details)
		browser.text_field(name: "FirstName").set first_name
		browser.text_field(name: "LastName").set last_name
		browser.text_field(name: "Email").set email
		browser.text_field(name: "PhoneNumber").set phone_number
		browser.button(value: "Confirm").click
		sleep 1
		if browser.div(:class => "validation-summary-errors").exists?
			false
		else
			true
		end
	end

	def modify new_time
		browser = Watir::Browser.new :phantomjs
		browser.get "https://m.opentable.com/reservation/cancelreservation?ConfirmationID=#{confirmation_id}&RestaurantId=#{restaurant_id}"
	end


	def cancel
		browser = Watir::Browser.new :phantomjs
		browser.goto "https://m.opentable.com/reservation/cancelreservation?ConfirmationID=#{confirmation_id}&RestaurantId=#{restaurant_id}"
	end

end
# https://m.opentable.com/reservation/cancelreservation?ConfirmationNumber=1275541851
# https://m.opentable.com/reservation/cancelreservation?ConfirmationId=1191205888&RestaurantId=115105
# http://m.opentable.com/restaurants/jardiniere/27?Rid=27&EarlyPoints=0&ExactPoints=0&LaterPoints=0&SearchDateTime=11%2F11%2F2014%2019%3A30%3A00&PartySize=2&ConfirmationNumber=1275541851&OfferConfirmNumber=0&ChosenOfferId=0&ReservationStatus=Make