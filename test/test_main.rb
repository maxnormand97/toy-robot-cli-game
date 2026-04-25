# frozen_string_literal: true

require 'minitest/autorun'
require 'stringio'
require_relative '../main'

class ToyRobotCLITest < Minitest::Test
  def test_run_prints_welcome_and_help_on_startup
    output = run_cli("EXIT\n")

    assert_includes output, 'Welcome to the Toy Robot CLI Game!'
    assert_includes output, 'Commands:'
    assert_includes output, 'PLACE X,Y,O'
  end

  def test_help_command_prints_usage_information
    output = run_cli("HELP\nEXIT\n")

    assert_includes output, 'HELP or ?    Show this help message'
    assert_operator output.scan('Commands:').length, :>=, 2
  end

  def test_question_mark_alias_prints_help
    output = run_cli("?\nEXIT\n")

    assert_operator output.scan('Commands:').length, :>=, 2
  end

  def test_valid_command_sequence_reports_robot_position
    output = run_cli("PLACE 0,0,N\nMOVE\nRIGHT\nMOVE\nREPORT\nEXIT\n")

    assert_includes output, '1,1,E'
  end

  def test_report_before_placement_prints_error_message
    output = run_cli("REPORT\nEXIT\n")

    assert_includes output, 'Robot must be placed first using PLACE X,Y,O'
  end

  def test_invalid_place_format_prints_usage_message
    output = run_cli("PLACE 1,2\nEXIT\n")

    assert_includes output, 'Invalid PLACE format. Use: PLACE X,Y,O'
  end

  def test_place_outside_grid_prints_bounds_error
    output = run_cli("PLACE 6,6,N\nEXIT\n")

    assert_includes output, 'Position 6,6 is outside a 6x6 grid'
  end

  def test_second_place_repositions_robot
    output = run_cli("PLACE 0,0,N\nPLACE 1,1,E\nREPORT\nEXIT\n")

    assert_includes output, '1,1,E'
  end

  def test_move_that_would_leave_grid_prints_error_and_preserves_state
    output = run_cli("PLACE 0,0,S\nMOVE\nREPORT\nEXIT\n")

    assert_includes output, 'Position 0,-1 is outside a 6x6 grid'
    assert_includes output, '0,0,S'
  end

  def test_unknown_command_prints_guidance
    output = run_cli("DANCE\nEXIT\n")

    assert_includes output, 'Unknown command. Type HELP to see the available commands.'
  end

  def test_blank_lines_are_ignored
    output = run_cli("\n\nEXIT\n")

    assert_equal 3, output.scan('> ').length
  end

  private

  def run_cli(commands)
    input = StringIO.new(commands)
    output = StringIO.new

    ToyRobotCLI.new(input: input, output: output).run

    output.string
  end
end
