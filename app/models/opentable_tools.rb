class OpentableTools
	@@base_reserve_url = "https://m.opentable.com/reservation/details?"
	attr_accessor :restaurant_id, :date_time, :party_size, :first_name, :last_name, :email, :phone_number, :r_details, :browser, :confirmation_id

	def initialize options=nil
		options = {restaurant_id: 105223, date_time: "11%2F13%2F2014%2021%3A30%3A00", party_size: 2, first_name: "Robert", last_name: "Gustavez", email: "neohzla@gmail.com", phone_number: "4157760400"} if !options
		@restaurant_id = options[:restaurant_id]
		@date_time = options[:date_time] #11/04/2014 16:00 in local time
		@party_size = options[:party_size]
		@first_name = options[:first_name]
		@last_name = options[:last_name]
		@email = options[:email]
		@confirmation_id
		@phone_number = options[:phone_number] || "9499813668"
	end

	def r_details
		"RestaurantID=#{restaurant_id}&Points=100&SecurityID=0&DateTime=#{date_time}&PartySize=#{party_size}&OfferConfirmNumber=0&ChosenOfferId=0&IsMiddleSlot=False&ArePopPoints=False"
	end

	def increment_time
		if date_time[-7] == "3"
			self.date_time[-7] = "0"
			self.date_time[-11] = (date_time[-11].to_i + 1).to_s 
		else
			self.date_time[-7] = "3"
		end
	end

	def reserve
		count = 0
		created = false
		browser = Watir::Browser.new :phantomjs
		until count == 2 || created == true
			browser.goto(@@base_reserve_url + r_details)
			browser.text_field(name: "FirstName").set first_name
			browser.text_field(name: "LastName").set last_name
			browser.text_field(name: "Email").set email
			browser.text_field(name: "PhoneNumber").set phone_number
			#browser.button(value: "Confirm").click
			sleep 1
			if true
				count += 1
				increment_time
			else
				begin
					confirmation_id = /ConfirmationNumber=(\d*)/.match(browser.url)[1]
					meal = Meal.create url: browser.url, confirmation_id: confirmation_id
					created = meal
				rescue
					created = false
				end
			end
		end
		if created
			created
		else
			{url: browser.url }
		end
	end

	def modify meal, new_time
		browser = Watir::Browser.new :phantomjs
		browser.get meal.url
	end

	def self.cancel meal
		browser = Watir::Browser.new :phantomjs
		browser.goto meal.url
		browser.link(id: "CancelButton").click
		browser.button(id: "dynamicDialogYes").click
		meal.destroy
	end
end


# https://m.opentable.com/reservation/cancelreservation?ConfirmationId=1191205888&RestaurantId=115105