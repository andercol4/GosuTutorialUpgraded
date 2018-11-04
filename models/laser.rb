require 'gosu'
require 'pry'
class Laser
  attr_reader :x, :y, :angle

  def initialize(angle, x, y)
    @image = Gosu::Image.new("media/laser.png")
    @angle = angle
    @x = x
    @y = y
    @vel_x = Gosu.offset_x(@angle, 2.1)
    @vel_y = Gosu.offset_y(@angle, 2.1)
  end

  def move
    @x += @vel_x
    @y += @vel_y
  end

  def draw
    @image.draw_rot(
      @x, @y,
      ZOrder::OBSTICALS,
      (@angle - 118),
    )
  end

  def out_of_bounds?
    # @x > width || @y > height || @x < 0 || @y < 0
    false
  end

  def hit_asteroid(asteroids)
    asteroids.find do |asteroid|
      Gosu.distance(@x, @y, asteroid.x, asteroid.y) < 35
    end
  end
end
