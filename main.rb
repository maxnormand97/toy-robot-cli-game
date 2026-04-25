# frozen_string_literal: true

require_relative 'grid'
require_relative 'robot'

# Simple REPL for the toy robot exercise, acts as an entry point for the CLI.
class ToyRobotCLI
  GRID_SIZE = 6
  DIRECT_COMMANDS = {
    'MOVE' => :move,
    'LEFT' => :left,
    'RIGHT' => :right,
    'REPORT' => :report,
    'HELP' => :print_help,
    '?' => :print_help
  }.freeze

  def initialize(input: $stdin, output: $stdout, robot: Robot.new(Grid.new(GRID_SIZE)))
    @input = input
    @output = output
    @robot = robot
  end

  # rubocop:disable Metrics/MethodLength
  def run
    output.puts 'Welcome to the Toy Robot CLI Game!'
    print_help

    # REPL programs run in a continuous loop waiting for user input until they are canceled
    loop do
      output.print '> '
      raw_command = input.gets
      break if raw_command.nil?

      command = raw_command.strip
      next if command.empty?
      break if command.casecmp('EXIT').zero?

      handle(command)
    end
  end
  # rubocop:enable Metrics/MethodLength

  private

  attr_reader :input, :output, :robot

  def handle(command)
    return handle_place(command) if command.match?(/\APLACE\b/i)

    action = DIRECT_COMMANDS[command.upcase]
    return execute(action) if action

    output.puts 'Unknown command. Type HELP to see the available commands.'
  end

  def handle_place(command)
    arguments = parse_place_arguments(command)
    return unless arguments

    # Using Splat (*) we can take the array arguments (like [2, 3, "N"]) and pass
    # each value as a separate argument to robot.place.
    # So robot.place(*arguments) is the same as robot.place(2, 3, "N").
    robot.place(*arguments)
    print_last_error if robot.last_error
  end

  def execute(action)
    # If the CLI class has a method for this action (like print_help), call it;
    # otherwise, call the method on the robot (like move, left, right, report).
    # This lets us handle both CLI and robot commands with one line using simple
    # meta-programming
    result = respond_to?(action, true) ? send(action) : robot.public_send(action)
    output.puts(result) if action == :report && result
    return result unless result == false

    print_last_error if robot.last_error
  end

  # This method takes a PLACE command (like "PLACE 2,3,N") and tries to extract the
  # X, Y, and orientation values.
  # If the command is in the correct format, it returns an array like [2, 3, "N"].
  # If the format is wrong, it prints an error message and returns nil.
  def parse_place_arguments(command)
    match = command.match(/\APLACE\s+(-?\d+)\s*,\s*(-?\d+)\s*,\s*([[:alpha:]]+)\z/i)
    unless match
      output.puts 'Invalid PLACE format. Use: PLACE X,Y,O'
      return nil
    end

    [match[1].to_i, match[2].to_i, match[3]]
  end

  def print_last_error
    output.puts robot.last_error.message
  end

  def print_help
    output.puts 'Commands:'
    output.puts '  PLACE X,Y,O  Place the robot on the 6x6 grid facing N, E, S, or W'
    output.puts '  MOVE         Move one space forward'
    output.puts '  LEFT         Turn 90 degrees left'
    output.puts '  RIGHT        Turn 90 degrees right'
    output.puts '  REPORT       Print the current position and orientation'
    output.puts '  HELP or ?    Show this help message'
    output.puts '  EXIT         Quit the game'
    true
  end
end

ToyRobotCLI.new.run if $PROGRAM_NAME == __FILE__
