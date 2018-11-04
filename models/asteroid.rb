require 'gosu'
require 'pry'
class Asteroid
  attr_reader :x, :y

  def initialize
    @image = Gosu::Image.new("media/asteroid.png")
    @angle = rand(0.0..360.0)
    @path = rand(0.0..360.0)
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
    warp(100, 100)
  end
end
