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

end
