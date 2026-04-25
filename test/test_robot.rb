# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../grid'
require_relative '../robot'
require_relative '../robot_errors'

class RobotTest < Minitest::Test
  def setup
    @robot = Robot.new
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
    assert_equal [2, 3], @robot.instance_variable_get(:@position)
    assert_equal 'N', @robot.instance_variable_get(:@orientation)
    assert_nil @robot.last_error
  end

  def test_place_normalizes_orientation_case
    assert_equal true, @robot.place(2, 3, 'n')
    assert_equal 'N', @robot.instance_variable_get(:@orientation)
  end

  def test_place_ignores_invalid_position
    @robot.place(6, 6, 'N') # Out of bounds
    assert_equal [], @robot.instance_variable_get(:@position)
    assert_nil @robot.instance_variable_get(:@orientation)
    assert_equal :position_out_of_bounds, @robot.last_error.code
  end

  def test_move_within_bounds
    @robot.place(0, 0, 'N')
    assert_equal true, @robot.move
    assert_equal [0, 1], @robot.instance_variable_get(:@position)

    @robot.right # Now facing East
    assert_equal true, @robot.move
    assert_equal [1, 1], @robot.instance_variable_get(:@position)
  end

  def test_move_ignores_out_of_bounds_south
    @robot.place(0, 0, 'S')
    assert_equal false, @robot.move
    assert_equal [0, 0], @robot.instance_variable_get(:@position)
  end

  def test_move_ignores_out_of_bounds_west
    @robot.place(0, 0, 'W')
    assert_equal false, @robot.move
    assert_equal [0, 0], @robot.instance_variable_get(:@position)
  end

  # TODO: / CHECK: can multiple robots be on the same Grid? if so this test is false
  def test_move_ignores_out_of_bounds_north
    robot2 = Robot.new
    robot2.place(Grid::DEFAULT_SIZE - 1, Grid::DEFAULT_SIZE - 1, 'N')
    assert_equal false, robot2.move
    assert_equal [Grid::DEFAULT_SIZE - 1, Grid::DEFAULT_SIZE - 1], robot2.instance_variable_get(:@position)
  end

  def test_left_and_right_turns
    @robot.place(0, 0, 'N')
    assert_equal 'N', @robot.instance_variable_get(:@orientation)

    @robot.left
    assert_equal 'W', @robot.instance_variable_get(:@orientation)

    @robot.left
    assert_equal 'S', @robot.instance_variable_get(:@orientation)

    @robot.right
    assert_equal 'W', @robot.instance_variable_get(:@orientation)

    @robot.right
    assert_equal 'N', @robot.instance_variable_get(:@orientation)
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
    @robot.place(2, 3, 'A') # Invalid orientation
    assert_equal [], @robot.instance_variable_get(:@position)
    assert_nil @robot.instance_variable_get(:@orientation)
    assert_equal :invalid_orientation, @robot.last_error.code
  end

  def test_place_can_be_called_more_than_once
    result1 = @robot.place(1, 1, 'E')
    result2 = @robot.place(2, 2, 'S')
    assert_equal true, result1
    assert_equal true, result2
    assert_equal [2, 2], @robot.instance_variable_get(:@position)
    assert_equal 'S', @robot.instance_variable_get(:@orientation)
    assert_nil @robot.last_error
  end
end
