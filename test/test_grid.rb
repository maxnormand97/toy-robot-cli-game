# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../grid'
require_relative '../grid_errors'

class GridTest < Minitest::Test
  def setup
    @grid = Grid.new
  end

  def test_valid_position_accepts_points_within_default_bounds
    assert_equal true, @grid.valid_position?(0, 0)
    assert_equal true, @grid.valid_position?(Grid::DEFAULT_SIZE - 1, Grid::DEFAULT_SIZE - 1)
  end

  def test_valid_position_rejects_out_of_bounds_points
    assert_equal false, @grid.valid_position?(Grid::DEFAULT_SIZE, 0)
    assert_equal false, @grid.valid_position?(0, Grid::DEFAULT_SIZE)
    assert_equal false, @grid.valid_position?(-1, 0)
    assert_equal false, @grid.valid_position?(0, -1)
  end

  def test_valid_position_rejects_non_integer_values
    assert_equal false, @grid.valid_position?('1', 1)
    assert_equal false, @grid.valid_position?(1, nil)
  end

  def test_validate_position_raises_for_invalid_coordinate_type
    error = assert_raises(InvalidCoordinateTypeError) do
      @grid.validate_position!('1', 1)
    end

    assert_equal :invalid_coordinate_type, error.code
  end

  def test_validate_position_raises_for_out_of_bounds_coordinates
    error = assert_raises(PositionOutOfBoundsError) do
      @grid.validate_position!(Grid::DEFAULT_SIZE, Grid::DEFAULT_SIZE)
    end

    assert_equal :position_out_of_bounds, error.code
  end

  def test_initialize_raises_for_invalid_size
    error = assert_raises(InvalidGridSizeError) do
      Grid.new(0)
    end

    assert_equal :invalid_grid_size, error.code
  end

  def test_corner_exit_for_returns_destination_corner_for_valid_exit_directions
    assert_equal [Grid::DEFAULT_SIZE - 1, 0], @grid.corner_exit_for(Grid::DEFAULT_SIZE - 1, Grid::DEFAULT_SIZE - 1, 'N')
    assert_equal [0, Grid::DEFAULT_SIZE - 1], @grid.corner_exit_for(0, 0, 'S')
  end

  def test_corner_exit_for_returns_nil_for_non_corner_or_non_exit_direction
    assert_nil @grid.corner_exit_for(1, 1, 'N')
    assert_nil @grid.corner_exit_for(0, 0, 'N')
  end
end
