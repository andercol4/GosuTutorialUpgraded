require 'gosu'
require 'pry'
class Asteroid
  attr_reader :x, :y

  def initialize
    @image = Gosu::Image.new("media/asteroid.png")
    @angle = rand(0.0..360.0)
    @path = rand(0.0..359.9)
    @vel_x = Gosu.offset_x(@path, 0.6)
    @vel_y = Gosu.offset_y(@path, 0.6)
    start_location
  end

  def warp(x, y)
    @x, @y = x, y
  end

  def move
    @x += @vel_x
    @y += @vel_y
    @x %= 640
    @y %= 480
    @angle += 2.5
  end

  def draw
    @image.draw_rot(
      @x, @y,
      ZOrder::OBSTICALS,
      @angle,
    )
  end

  def start_location
    # Window Width 640,
    # Window Height 480
    # Tells me which direction its going
    angle_quadrant = @path / 90
    # if it is heading up generally
    if angle_quadrant >= 3.5 || angle_quadrant <= 0.5
      warp(rand(0..639), 0)
    # if it is heading right generally
  elsif angle_quadrant <= 1.5 && angle_quadrant >= 0.5
    # if it is heading left generally
    warp(0, rand(0..479))
  elsif angle_quadrant <= 2.5 && angle_quadrant >= 1.5
    # if it is heading down generally
    warp(rand(0..639), 480)
  elsif angle_quadrant <= 3.5 && angle_quadrant >= 2.5
      warp(640, rand(0..479))
    end
  end
end
