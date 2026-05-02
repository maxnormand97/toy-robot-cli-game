# frozen_string_literal: true

require_relative 'grid_errors'

# Represents the square grid the robot can move on.
class Grid
  DEFAULT_SIZE = 6
  CORNER_NAMES = %i[sw nw ne se].freeze

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

  def corner_position?(x_axis, y_axis)
    corner_name_for(x_axis, y_axis)
  end

  def corner_exit_for(x_axis, y_axis, orientation)
    corner_name = corner_name_for(x_axis, y_axis)
    return nil unless corner_name

    mapping = corner_exit_map[corner_name]
    destination_corner_name = mapping[orientation]
    return nil unless destination_corner_name

    corner_coordinates.fetch(destination_corner_name)
  end

  def validate_position!(x_axis, y_axis)
    raise InvalidCoordinateTypeError.new(x_axis, y_axis) unless integer_coordinates?(x_axis, y_axis)
    raise PositionOutOfBoundsError.new(x_axis, y_axis, @size) unless within_bounds?(x_axis, y_axis)

    true
  end

  private

  def corner_exit_map
    {
      sw: { 'S' => :nw, 'W' => :se },
      nw: { 'N' => :sw, 'W' => :ne },
      ne: { 'N' => :se, 'E' => :nw },
      se: { 'S' => :ne, 'E' => :sw }
    }
  end

  def corner_coordinates
    max = @size - 1
    {
      sw: [0, 0],
      nw: [0, max],
      ne: [max, max],
      se: [max, 0]
    }
  end

  def corner_name_for(x_axis, y_axis)
    corner_coordinates.each do |name, coordinates|
      return name if coordinates == [x_axis, y_axis]
    end

    nil
  end

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
