require("pry")
require_relative("../db/sql_runner")
require_relative("./customer")
require_relative("./film")
require_relative("./screening")

class Ticket

  attr_accessor :film_id, :customer_id, :screening_id
  attr_reader :id

  def initialize(options)
    @id = options["id"].to_i if options["id"]
    @film_id = options["film_id"]
    @customer_id = options["customer_id"]
    @screening_id = options["screening_id"]
  end

  def save()
    sql = "INSERT INTO tickets (film_id, customer_id, screening_id)
    VALUES
    (
      $1, $2, $3
    )
    RETURNING id"

    values = [@film_id, @customer_id, @screening_id]
    ticket_data = SqlRunner.run(sql, values).first
    @id = ticket_data["id"].to_i
  end

  def self.all()
    sql = "SELECT * FROM tickets"
    all_tickets = SqlRunner.run(sql)
    return all_tickets.map {|ticket| Ticket.new(ticket)}
  end

  def update()
    sql = "UPDATE tickets SET film_id = $1, customer_id = $2, screening_id = $3 WHERE id = $4"

    values = [@film_id, @customer_id, @screening_id ,@id]
    SqlRunner.run(sql, values).first
  end

  def self.delete_all()
    sql = "DELETE FROM tickets"
    SqlRunner.run(sql)
  end

  def filmPrice # Retrieves film price from films table
    sql = "SELECT * FROM films WHERE id = $1"

    values = [@film_id]
    film_hash = SqlRunner.run(sql, values).first
    # filmEntry[:price] # Accessing film_hash is not possible
    film = Film.new(film_hash) # Converted to object for acccess
    return film.price.to_i # Return price as integer

    binding.pry
  end




end
