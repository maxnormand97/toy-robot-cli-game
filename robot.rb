# frozen_string_literal: true

require_relative 'grid'
require_relative 'grid_errors'
require_relative 'robot_errors'

# Creates a robot that will move along a specified grid, the default is set to 6 x 6
class Robot
  DIRECTIONS = %w[N E S W].freeze

  # DELTAS maps each orientation to its movement vector (dx, dy).
  # This replaces a case statement for readability and maintainability.
  DELTAS = {
    'N' => [0, 1],   # North: move up (y+1)
    'E' => [1, 0],   # East:  move right (x+1)
    'S' => [0, -1],  # South: move down (y-1)
    'W' => [-1, 0]   # West:  move left (x-1)
  }.freeze

  attr_reader :last_error

  def placed?
    !@position.empty? && !@orientation.nil?
  end

  def initialize(grid = Grid.new)
    @grid = grid
    @orientation = nil # is the robot facing N, S, E, W
    @position = [] # where is the robot on the grid now; [] means not placed yet
    @last_error = nil
  end

  # where to place to robot on the grid up / down, left / right and orientation / rotation axis
  def place(x_axis, y_axis, orientation)
    normalized_orientation = normalize_orientation(orientation)
    validate_and_place(x_axis, y_axis, normalized_orientation)
    true
  rescue RobotError, GridError => e
    @last_error = e
    # NOTE: we can consider just returning @last_error instead of false in our rescues
    false
  end

  # moves the robot one step forward in whatever direction it is facing
  def move
    ensure_placed!
    perform_move
    true
  rescue RobotError, GridError => e
    @last_error = e
    false
  end

  # turns robot 90 degrees to the left
  def left
    rotate(-1)
  end

  # turns robot 90 degrees to the right
  def right
    rotate(1)
  end

  # Outputs where the robot currently is
  def report
    ensure_placed!
    generate_report
  rescue RobotError => e
    @last_error = e
    false
  end

  private

  def rotate(step)
    ensure_placed!
    perform_rotation(step)
    true
  rescue RobotError => e
    @last_error = e
    false
  end

  def perform_rotation(step)
    idx = DIRECTIONS.index(@orientation)
    @orientation = DIRECTIONS[(idx + step) % DIRECTIONS.size]
    clear_last_error
  end

  def perform_move
    new_x, new_y = next_position

    if @grid.valid_position?(new_x, new_y)
      @position = [new_x, new_y]
    else
      corner_exit = @grid.corner_exit_for(@position[0], @position[1], @orientation)
      raise PositionOutOfBoundsError.new(new_x, new_y, @grid.size) unless corner_exit

      @position = corner_exit
    end

    clear_last_error
  end

  def validate_and_place(x_axis, y_axis, orientation)
    @grid.validate_position!(x_axis, y_axis)
    validate_orientation!(orientation)

    @position = [x_axis, y_axis]
    @orientation = orientation
    clear_last_error
  end

  def generate_report
    output = "#{@position[0]},#{@position[1]},#{@orientation}"
    clear_last_error
    output
  end

  def ensure_placed!
    raise RobotNotPlacedError if @position.empty? || @orientation.nil?
  end

  def validate_orientation!(orientation)
    raise InvalidOrientationError.new(orientation, DIRECTIONS) unless DIRECTIONS.include?(orientation)
  end

  def normalize_orientation(orientation)
    orientation.to_s.strip.upcase
  end

  # Computes the next position based on current orientation using DELTAS.
  def next_position
    delta_x, delta_y = DELTAS.fetch(@orientation)
    [@position[0] + delta_x, @position[1] + delta_y]
  end

  def clear_last_error
    @last_error = nil
  end
end
