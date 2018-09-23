require("pry")
require_relative("../db/sql_runner")
require_relative("./ticket")

class Film

  attr_accessor :title, :price
  attr_reader :id

  def initialize(options)
    @id = options["id"].to_i if options["id"]
    @title = options["title"]
    @price = options["price"]
  end

  def save()
    sql = "INSERT INTO films (title, price)
    VALUES
    ($1, $2)
    RETURNING id"

    values = [@title, @price]
    film_data = SqlRunner.run(sql, values).first
    @id = film_data["id"].to_i
  end

  def self.all()
    sql = "SELECT * FROM films"
    all_films = SqlRunner.run(sql)
    return all_films.map {|film| Film.new(film)}
  end

  def numberOfCustomers() # Counts number of tickets sold for this film
    return whichCustomers.length
  end

  def update()
    sql = "UPDATE films SET title = $1, price = $2 WHERE id = $3"

    values = [@title, @price, @id]
    SqlRunner.run(sql, values).first
  end

  def self.delete_all()
    sql = "DELETE FROM films"
    SqlRunner.run(sql)
  end

  def whichCustomers
    sql = "SELECT customers.*, tickets.*
    FROM customers INNER JOIN tickets
    ON tickets.customer_id = customers.id
    WHERE film_id = $1"

    values = [@id]
    custs = SqlRunner.run(sql, values)
    custs.map {|cust| Customer.new(cust)}
  end

  def popularTime()
    sql = "SELECT screenings.start_time,
    tickets.screening_id,
    films.id,
    films.title
    FROM screenings
    INNER JOIN tickets
    ON tickets.screening_id = screenings.id
    INNER JOIN films
    ON tickets.film_id = films.id WHERE films.id = $1"
# tickets.film_id,
    values = [@id]
    film_hash = SqlRunner.run(sql,values)
    filmArray = film_hash.map {|film| film}
    #Enumerator counts element occurences.
    mostPopular = filmArray.max_by {|screening| screening[:start_time]}
    binding.pry
  end

end
