require 'gosu'
require 'pry'
class Asteroid
  def initialize
    @image = Gosu::Image.new("media/asteroid.png")
    @crash = Gosu::Sample.new("media/crash.wav")
    @color = Gosu::Color::BLACK.dup
    @color.red = rand(256 - 40) + 40
    @color.green = rand(256 - 40) + 40
    @color.blue = rand(256 - 40) + 40
    @x = @y = 0.0
    @angle = rand(0.0..360.0)
    @vel_x = Gosu.offset_x(@angle, 0.5)
    @vel_y = Gosu.offset_y(@angle, 0.5)
    start_location
  end

  def warp(x, y)
    @x, @y = x, y
  end

  def accelerate
    @vel_x += Gosu.offset_x(@angle, 0.5)
    @vel_y += Gosu.offset_y(@angle, 0.5)
  end

  def move
    @x += @vel_x
    @y += @vel_y
    @x %= 640
    @y %= 480

    @vel_x *= 0.95
    @vel_y *= 0.95
  end

  def draw
    @image.draw_rot(@x, @y, ZOrder::OBSTICALS, @angle)
  end

  def start_location
    warp(100, 100)
  end
end
