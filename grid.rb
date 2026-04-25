# frozen_string_literal: true

require_relative 'grid_errors'

# Represents the square grid the robot can move on.
class Grid
  DEFAULT_SIZE = 6

  attr_reader :size

  def initialize(size = DEFAULT_SIZE)
    raise InvalidGridSizeError, size unless valid_size?(size)

    @size = size
  end

  def valid_position?(x_axis, y_axis)
    validate_position!(x_axis, y_axis)
    true
  rescue GridError
    false
  end

  def validate_position!(x_axis, y_axis)
    raise InvalidCoordinateTypeError.new(x_axis, y_axis) unless integer_coordinates?(x_axis, y_axis)
    raise PositionOutOfBoundsError.new(x_axis, y_axis, @size) unless within_bounds?(x_axis, y_axis)

    true
  end

  private

  def valid_size?(size)
    size.is_a?(Integer) && size.positive?
  end

  def integer_coordinates?(x_axis, y_axis)
    x_axis.is_a?(Integer) && y_axis.is_a?(Integer)
  end

  def within_bounds?(x_axis, y_axis)
    x_axis.between?(0, @size - 1) && y_axis.between?(0, @size - 1)
  end
end
