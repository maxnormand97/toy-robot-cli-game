# frozen_string_literal: true

# Base error for Robot-related failures.
class RobotError < StandardError
  attr_reader :code

  def initialize(message, code)
    super(message)
    @code = code
  end
end

class RobotNotPlacedError < RobotError
  def initialize
    super('Robot must be placed first using PLACE X,Y,O', :robot_not_placed)
  end
end

class InvalidOrientationError < RobotError
  def initialize(orientation, directions)
    super("Orientation must be one of #{directions.join(', ')}, received: #{orientation.inspect}", :invalid_orientation)
  end
end
