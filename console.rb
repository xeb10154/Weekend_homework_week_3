require("pry") # Or pry-byebug?
require_relative("./models/customer")
require_relative("./models/film")
require_relative("./models/ticket")
require_relative("./models/screening")

Customer.delete_all
Film.delete_all
Screening.delete_all
Ticket.delete_all

#---Customer objects---
customer1 = Customer.new({
"name" => "Raymond",
"funds" => 25
})
customer1.save()

customer2 = Customer.new({
"name" => "Rique",
"funds" => 60
})
customer2.save()

customer3 = Customer.new({
"name" => "Colin",
"funds" => 90
})
customer3.save()


# ---Film objects---
film1 = Film.new({
"title" => "The Imitation Game",
"price" => 15
})
film1.save()

film2 = Film.new({
"title" => "A Beautiful Mind",
"price" => 15
})
film2.save()

film3 = Film.new({
"title" => "Transformers 21 (3D)",
"price" => 30
})
film3.save()

#---Screening objects---
screening1 = Screening.new({
"start_time" => "13:00",
"empty_seats" => 10,
"film_id" => film1.id
})
screening1.save()

screening2 = Screening.new({
"start_time" => "15:30",
"empty_seats" => 2, # only 2 seats max
"film_id" => film2.id
})
screening2.save()

screening3 = Screening.new({
"start_time" => "20:00",
"empty_seats" => 15,
"film_id" => film3.id
})
screening3.save()

#---Ticket objects---

ticket1 = Ticket.new({
"film_id" => film1.id,
"customer_id" => customer1.id,
"screening_id" => screening1.id
})
ticket1.save()


# Customer2 bought both ticket2 and ticket3 for different films
ticket2 = Ticket.new({
"film_id" => film2.id,
"customer_id" => customer2.id,
"screening_id" => screening2.id
})
ticket2.save()

ticket3 = Ticket.new({
"film_id" => film3.id,
"customer_id" => customer2.id,
"screening_id" => screening3.id
})
ticket3.save()

#---Customer3 bought both ticket4 and ticket5 to the same film3
ticket4 = Ticket.new({
"film_id" => film3.id,
"customer_id" => customer3.id,
"screening_id" => screening3.id
})
ticket4.save()

ticket5 = Ticket.new({
"film_id" => film3.id,
"customer_id" => customer3.id,
"screening_id" => screening3.id
})
ticket5.save()

#---Testing Updates
customer1.name = "Ray"
customer1.update()

ticket1.film_id = film2.id
ticket1.update()

film1.title = "Enigma"
film1.update()

screening1.empty_seats = 5
screening1.update()

# Find which films has a specific customer has seen
customer2.whichFilms()

# Find which customers has been to see a specific film
film3.whichCustomers()

# Test deduct price of ticket sold
customer1.purchase(ticket1.filmPrice)

# Test deduct price with insuffient funds (no amount deducted)
customer1.purchase(ticket3.filmPrice)

# Count number of tickets customer bought
customer2.countTickets()

# Count number of customers going to see a certain film
film3.numberOfCustomers()

# Show all film screenings with corresponding start_times
Screening.allFilmTimes() # Returns an array of hashes





#---testing with Pry---
binding.pry

nil
