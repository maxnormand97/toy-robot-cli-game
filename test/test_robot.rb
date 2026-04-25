# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../robot'

class RobotTest < Minitest::Test
  # TODO: fill out unit test cases later
  def test_say_gday
    robot = Robot.new
    assert_respond_to robot, :say_gday
  end
end
