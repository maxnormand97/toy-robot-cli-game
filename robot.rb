# frozen_string_literal: true

# NOTES:
# We may actually want to have a Grid class, because the Grid itself is a separate entity
# to the Robot, we would break the single responsibility principle if we handled that logic here!

# TODO: for each edge case return we should raise an error and then rescue it, for now return false!
# TODO: remove rubocop when error messaging is better set up.

# Creates a robot that will move along a grid of 6 x 6
# rubocop:disable Naming/PredicateMethod
class Robot
  DIRECTIONS = %w[N E S W].freeze
  GRID_SIZE = 6

  # CHECK: should the Robot have an initial orientation and position is it okay to be nil?
  def initialize
    @orientation = nil # is the robot facing N, S, E, W
    @position = [] # where is the robot on the grid now; [] means not placed yet
  end

  # where to place to robot on the grid up / down, left / right and orientation / rotation axis
  def place(x_axis, y_axis, orientation)
    # Prevent re-placement if already placed
    return false unless @position.empty?

    # Validate the Position and orientation of the robot
    return false unless valid_position?(x_axis, y_axis) && valid_orientation?(orientation)

    @position = [x_axis, y_axis]
    @orientation = orientation
    true
  end

  # moves the robot one step forward in whatever direction it is facing
  # TODO: we will have to clean this method up so it is neater and passes rubocop
  # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength
  def move
    return false if @position.empty? || @orientation.nil?

    x, y = @position

    # NOTE: not as readable as it cold be using the index of the array maybe
    # consider a cleaner implementation of the const
    case @orientation
    when DIRECTIONS[0] # "N"
      new_x = x
      new_y = y + 1
    when DIRECTIONS[1] # "E"
      new_x = x + 1
      new_y = y
    when DIRECTIONS[2] # "S"
      new_x = x
      new_y = y - 1
    when DIRECTIONS[3] # "W"
      new_x = x - 1
      new_y = y
    end

    return false unless valid_position?(new_x, new_y)

    @position = [new_x, new_y]
    true
  end
  # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength

  # turns robot 90 degrees to the left
  def left
    # TODO: there is duplication here we could extract the validation to a method
    # and we could extract the orientation setting to a new helper method, we can
    # do this later
    return false if @position.empty? || @orientation.nil?

    idx = DIRECTIONS.index(@orientation)
    @orientation = DIRECTIONS[(idx - 1) % DIRECTIONS.size]
    true
  end

  # turns robot 90 degrees to the right
  def right
    return false if @position.empty? || @orientation.nil?

    idx = DIRECTIONS.index(@orientation)
    @orientation = DIRECTIONS[(idx + 1) % DIRECTIONS.size]
    true
  end

  # Outputs where the robot currently is
  # TODO: we should output a more readable format for the robots position
  def report
    return false if @position.empty? || @orientation.nil?

    output = "#{@position[0]},#{@position[1]},#{@orientation}"
    puts output
    output
  end

  private

  def valid_orientation?(orientation)
    DIRECTIONS.include?(orientation)
  end

  def valid_position?(x_axis, y_axis)
    x_axis.is_a?(Integer) && y_axis.is_a?(Integer) &&
      x_axis.between?(0, GRID_SIZE - 1) &&
      y_axis.between?(0, GRID_SIZE - 1)
  end
end
# rubocop:enable Naming/PredicateMethod
