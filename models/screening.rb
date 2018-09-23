require("pry")
require_relative("../db/sql_runner")
require_relative("./ticket")
require_relative("./film")

class Screening

  attr_accessor :film_id, :empty_seats, :start_time
  attr_reader :id

  def initialize(options)
    @id = options["id"].to_i if options["id"]
    @film_id = options["film_id"]
    @empty_seats = options["empty_seats"]
    @start_time = options["start_time"]
  end

  def save()
    sql = "INSERT INTO screenings (film_id, empty_seats, start_time)
    VALUES
    (
      $1, $2, $3
    )
    RETURNING id"

    values = [@film_id, @empty_seats, @start_time]
    screening_data = SqlRunner.run(sql, values).first
    @id = screening_data["id"].to_i
  end

  def self.all()
    sql = "SELECT * FROM screenings"
    all_screenings = SqlRunner.run(sql)
    return all_screenings.map {|screening| Screening.new(screening)}
  end

  def update()
    sql = "UPDATE screenings SET film_id = $1, empty_seats = $2, start_time = $3
    WHERE id = $4"

    values = [@film_id, @empty_seats, @start_time, @id]
    SqlRunner.run(sql, values).first
  end

  def self.delete_all()
    sql = "DELETE FROM screenings"
    all_screenings = SqlRunner.run(sql)
  end

  def self.allFilmTimes()
    # sql = "SELECT * FROM screenings
    # INNER JOIN tickets
    # ON screenings.id = tickets.screening_id
    # INNER JOIN films
    # ON tickets.film_id = films.id"

    sql = "SELECT screenings.start_time, films.title
    FROM screenings INNER JOIN films
    ON screenings.film_id = films.id"

    all_screenings = SqlRunner.run(sql)
    all_screenings.map {|screening| screening}
    # binding.pry
  end
end
