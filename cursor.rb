class Cursor

  attr_reader :worksheet
  attr_reader :index

  def initialize(worksheet:)
    @worksheet = worksheet
    @index = 0
  end

  def add_to_next_cell(*values)
    values.each_with_index do |value, horizontal_index|
      worksheet.add_cell(index, horizontal_index, value)
    end
    move_cursor
  end

  def move_cursor
    @index += 1
  end

end
