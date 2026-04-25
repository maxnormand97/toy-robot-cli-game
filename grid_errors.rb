# frozen_string_literal: true

# Base error for Grid-related failures.
class GridError < StandardError
  attr_reader :code

  def initialize(message, code)
    super(message)
    @code = code
  end
end

class InvalidGridSizeError < GridError
  def initialize(size)
    super("Grid size must be a positive integer, received: #{size.inspect}", :invalid_grid_size)
  end
end

class InvalidCoordinateTypeError < GridError
  def initialize(x_axis, y_axis)
    super("Coordinates must be integers, received x=#{x_axis.inspect}, y=#{y_axis.inspect}", :invalid_coordinate_type)
  end
end

class PositionOutOfBoundsError < GridError
  def initialize(x_axis, y_axis, size)
    super("Position #{x_axis},#{y_axis} is outside a #{size}x#{size} grid", :position_out_of_bounds)
  end
end
