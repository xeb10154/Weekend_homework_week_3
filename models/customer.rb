require("pry")
require_relative("../db/sql_runner")
require_relative("./ticket")

class Customer

  attr_accessor :name, :funds
  attr_reader :id

  def initialize(options)
    @id = options["id"].to_i if options["id"]
    @name = options["name"]
    @funds = options["funds"]
  end

  def save()
    sql = "INSERT INTO customers (name, funds)
    VALUES
    ($1, $2)
    RETURNING id"

    values = [@name, @funds]
    customer_data = SqlRunner.run(sql, values).first
    @id = customer_data["id"].to_i
  end

  def countTickets()
    sql = "SELECT * FROM tickets WHERE customer_id = $1"

    values = [@id]
    allTickets = SqlRunner.run(sql, values)
    ticketsArray = allTickets.map {|ticket| Ticket.new(ticket)}
    return ticketsArray.length
  end

  def update()
    sql = "UPDATE customers SET name = $1, funds = $2 WHERE id = $3"

    values = [@name, @funds, @id]
    SqlRunner.run(sql, values).first
  end

  def self.delete_all()
    sql = "DELETE FROM customers"
    SqlRunner.run(sql)
  end

# Find which films customers has seen

  def whichFilms
    sql = "SELECT tickets.*, films.*
    FROM tickets INNER JOIN films
    ON tickets.film_id = films.id
    WHERE customer_id = $1"

    values = [@id]
    watched = SqlRunner.run(sql, values)
    watched.map {|film| Film.new(film)}
  end

  def purchase(filmPrice)
    if @funds >= filmPrice
      @funds -= filmPrice
    end
  end


end
