# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../robot'

class RobotTest < Minitest::Test
  def setup
    @robot = Robot.new
  end

  def test_robot_cannot_move_before_placement
    # assert that move, left, right, report do nothing before place is called
  end

  def test_place_sets_position_and_orientation
    # assert that place sets the correct position and orientation
  end

  def test_place_ignores_invalid_positions
    # assert that place ignores positions outside the grid
  end

  def test_move_within_bounds
    # assert that move updates position correctly within grid bounds
  end

  def test_move_ignores_out_of_bounds
    # assert that move does not update position if it would go off the grid
  end

  def test_left_and_right_turns
    # assert that left and right update orientation correctly
  end

  def test_report_outputs_position_and_orientation
    # assert that report returns the correct string or output
  end
end
