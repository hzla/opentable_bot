class OpentableTools 
	@@base_reserve_url = "https://m.opentable.com/reservation/details?"
	attr_accessor :restaurant_id, :date_time, :party_size, :first_name, :last_name, :email, :phone_number, :r_details

def initialize options=nil
	options = {restaurant_id: 105223, date_time: "11/13/2014 21:30:00", party_size: 2, first_name: "Robert", last_name: "Gustavez", email: "neohzla@gmail.com", phone_number: "4157760400"} if !options
	@restaurant_id = options[:restaurant_id]
	@date_time = URI.encode(options[:date_time]).gsub('/','%2F').gsub(':','%3A') #11/04/2014 16:00 in local time
	@party_size = options[:party_size]
	@first_name = options[:first_name]
	@last_name = options[:last_name]
	@email = options[:email]
	@phone_number = options[:phone_number] || "9499813668"
	@r_details = "RestaurantID=#{restaurant_id}&Points=100&SecurityID=0&DateTime=#{date_time}&PartySize=#{party_size}&OfferConfirmNumber=0&ChosenOfferId=0&IsMiddleSlot=False&ArePopPoints=False"
end

def reserve options=nil
	browser = Watir::Browser.new
	browser.goto(@@base_reserve_url + r_details)
	browser.text_field(name: "FirstName").set first_name
	browser.text_field(name: "LastName").set last_name
	browser.text_field(name: "Email").set email
	browser.text_field(name: "PhoneNumber").set phone_number
	browser.button(value: "Confirm").click
	sleep 1
	browser.div(:class => "browser-summary-errors").exists?
	p browser.url
end

def self.cancel restaurant_id, confirmation_id
	browser = Watir::Browser.new :phantomjs
	browser.goto "https://m.opentable.com/reservation/cancelreservation?ConfirmationId=#{confirmation_id}&RestaurantId=#{restaurant_id}"
end









# /reservation/details?RestaurantID=148204&Points=100&SecurityID=0&DateTime=11%2F04%2F2014%2019%3A00%3A00&PartySize=2
# FirstName, LastName, Email, PhoneNumber
# restaurant_id, date_time, party_size
# securityID=0, points=100, 

end


# https://m.opentable.com/reservation/cancelreservation?ConfirmationId=1191205888&RestaurantId=115105
# FirstName=Robert&LastName=Junior&Email=hzllyde%40gmail.com&PhoneNumber=9499813668&SpecialInstructions=&RestaurantName=Minas+Brazilian+Restaurant&FormattedDateTime=Tue+11%2F4%2F2014+9%3A30+PM&GuestText=%2B+1+guest%28s%29&OffersCsv=&ChosenOfferVersion=0&IsJustRegistered=False&IsForeignGuest=True&FormattedReservationDate=Tuesday%2C+November+04&FormattedReservationTimePartySize=9%3A30+PM+for+2+people
# OpentableTools.reserve restaurant_id: 1234, date_time: "11/04/2014 16:00", party_size: 6, first_name: "Andy", last_name: "Lee", email: "andylee.hzl@gmail.com", phone_number: "9499813668"