require_relative('../db/sql_runner')

class Student

  attr_reader  :first_name, :last_name, :house, :age, :id

  def initialize( options )
    @id = options['id'].to_i
    @first_name = options['first_name']
    @last_name = options['last_name']
    @house = options['house']
    @age = options['age'].to_i

  end

def full_name()
  return "#{@first_name} #{@last_name}"
end

def save()
    sql = "INSERT INTO students
    (
      first_name,
      last_name,
      house,
      age
    )
    VALUES
    (
      $1, $2, $3, $4
    )
    RETURNING *"
    values = [@first_name, @last_name, @house, @age]
    student_data = SqlRunner.run(sql, values)
    @id = student_data.first()['id'].to_i
  end

  def update()
    sql = "UPDATE students
    SET
    (
      first_name,
      last_name,
      house,
      age
    ) =
    (
      $1, $2, $3, $4
    )
    WHERE id = $5"
    values = [@first_name, @last_name, @house, @age, @id]
    SqlRunner.run( sql, values )
  end

  def self.find( id )
    sql = "SELECT * FROM students
    WHERE id = $1"
    values = [id]
    student = SqlRunner.run( sql, values )
    result = Student.new( student.first )
    return result
  end

  def self.all()
  sql = "SELECT * FROM students"
  student_data = SqlRunner.run( sql )
  result = student_data.map { |student_data| Student.new( student_data ) }
  return result
end

end
