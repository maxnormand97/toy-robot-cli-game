# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../grid'
require_relative '../robot'
require_relative '../robot_errors'

class RobotTest < Minitest::Test
  def setup
    @robot = Robot.new
  end

  def assert_robot_report(expected_report)
    assert_equal expected_report, @robot.report
    assert_nil @robot.last_error
  end

  def test_move_fails_before_placement
    assert_equal false, @robot.move
    assert_equal :robot_not_placed, @robot.last_error.code
  end

  def test_left_fails_before_placement
    assert_equal false, @robot.left
    assert_equal :robot_not_placed, @robot.last_error.code
  end

  def test_right_fails_before_placement
    assert_equal false, @robot.right
    assert_equal :robot_not_placed, @robot.last_error.code
  end

  def test_report_fails_before_placement
    assert_equal false, @robot.report
    assert_equal :robot_not_placed, @robot.last_error.code
  end

  def test_place_sets_position_and_orientation
    @robot.place(2, 3, 'N')
    assert_robot_report('2,3,N')
  end

  def test_place_normalizes_orientation_case
    assert_equal true, @robot.place(2, 3, 'n')
    assert_robot_report('2,3,N')
  end

  def test_place_ignores_invalid_position
    assert_equal false, @robot.place(6, 6, 'N') # Out of bounds
    assert_equal :position_out_of_bounds, @robot.last_error.code

    assert_equal false, @robot.move
    assert_equal :robot_not_placed, @robot.last_error.code
  end

  def test_move_within_bounds
    @robot.place(0, 0, 'N')
    assert_equal true, @robot.move
    assert_robot_report('0,1,N')

    @robot.right # Now facing East
    assert_equal true, @robot.move
    assert_robot_report('1,1,E')
  end

  def test_move_ignores_out_of_bounds_south
    @robot.place(0, 0, 'S')
    assert_equal false, @robot.move
    assert_equal :position_out_of_bounds, @robot.last_error.code
    assert_robot_report('0,0,S')
  end

  def test_move_ignores_out_of_bounds_west
    @robot.place(0, 0, 'W')
    assert_equal false, @robot.move
    assert_equal :position_out_of_bounds, @robot.last_error.code
    assert_robot_report('0,0,W')
  end

  def test_move_ignores_out_of_bounds_north
    @robot.place(Grid::DEFAULT_SIZE - 1, Grid::DEFAULT_SIZE - 1, 'N')
    assert_equal false, @robot.move
    assert_equal :position_out_of_bounds, @robot.last_error.code
    assert_robot_report("#{Grid::DEFAULT_SIZE - 1},#{Grid::DEFAULT_SIZE - 1},N")
  end

  def test_left_and_right_turns
    @robot.place(0, 0, 'N')
    assert_robot_report('0,0,N')

    @robot.left
    assert_robot_report('0,0,W')

    @robot.left
    assert_robot_report('0,0,S')

    @robot.right
    assert_robot_report('0,0,W')

    @robot.right
    assert_robot_report('0,0,N')
  end

  def test_report_outputs_position_and_orientation
    # Should return false if not placed
    assert_equal false, @robot.report

    @robot.place(4, 5, 'S')
    expected = '4,5,S'
    result = @robot.report
    assert_equal expected, result
  end

  def test_place_ignores_invalid_orientation
    assert_equal false, @robot.place(2, 3, 'A') # Invalid orientation
    assert_equal :invalid_orientation, @robot.last_error.code

    assert_equal false, @robot.right
    assert_equal :robot_not_placed, @robot.last_error.code
  end

  def test_place_can_be_called_more_than_once
    result1 = @robot.place(1, 1, 'E')
    result2 = @robot.place(2, 2, 'S')
    assert_equal true, result1
    assert_equal true, result2
    assert_robot_report('2,2,S')
  end
end
