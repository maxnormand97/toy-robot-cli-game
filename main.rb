# frozen_string_literal: true

# robot_cli.rb

require_relative 'robot'

robot = Robot.new

print 'Welcome to the Toy Robot CLI Game!'

loop do
  print '>'
  input = gets&.strip
  break if input.nil? || input.upcase == 'EXIT'

  if input.upcase == 'GDAY'
    robot.say_gday
    next
  end

  # TODO: buid out other commands here
end
