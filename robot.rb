# frozen_string_literal: true

# NOTES:
# We may actaully want to have a Grid class, because the Grid iteself is a seperate entity
# to the Robot, we would break the single responsiblity principle if we handled that logic here!

# Creates a robot that will move along a grid of 6 x 6
class Robot
  # TODO: probably want to define our constants for north

  def initialize
    # orientation - is the robot facing N, S, E, W
    # position - where is the robot on the grid now
  end

  # where to place to robot on the grid up / down, left / right and orientation / rotation axis
  def place(x_axis, y_axis, orientation)
    # CHECK: can this function only be called once per REPL session? Once the robot is on the Grid
    # it does not make sense to be able to call this function. Maybe the placement should occur in the
    # constructor

    # TODO: all other commands are to be ignored until the robot is placed!
  end

  # moves the robot one step forward in whicher direction it is facing
  def move
    # TODO: the robot must stay in the bounds of the grid, this must be handled here
  end

  # turns robot 90 degrees to the left
  def left; end

  # turns robot 90 degrees to the right
  def right; end

  # Outputs where the robot currently is
  def report; end
end
