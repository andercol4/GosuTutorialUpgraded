require 'gosu'
require 'pry'
Dir[File.join(__dir__, 'models', '*.rb')].each { |file| require file }

module ZOrder
  BACKGROUND, OBSTICALS, PLAYER, UI = *0..3
end


class Tutorial < Gosu::Window
  def initialize
    super 640, 480
    self.caption = "Stars and Stroids"
    @game_over = false
    @background_image = Gosu::Image.new("media/space.png", :tileable => true)
    @crash = Gosu::Sample.new("media/crash.wav")

    @player = Player.new
    @player.warp(320, 240)

    @star_anim = Gosu::Image.load_tiles("media/star.png", 25, 25)
    @stars = Array.new
    @asteroids = Array.new
    @lasers = Array.new
    @font = Gosu::Font.new(20)

  end

  def update
    unless @game_over
      player_movement
      update_objects
      @game_over = @player.crash(@asteroids)
    end
  end

  def draw
    @background_image.draw(0, 0, ZOrder::BACKGROUND)
    unless @game_over
      draw_game_screen
    else
      draw_game_over_screen
    end
  end

  def player_movement
    if Gosu.button_down? Gosu::KB_LEFT or Gosu::button_down? Gosu::GP_LEFT
      @player.turn_left
    end
    if Gosu.button_down? Gosu::KB_RIGHT or Gosu::button_down? Gosu::GP_RIGHT
      @player.turn_right
    end
    if Gosu.button_down? Gosu::KB_UP or Gosu::button_down? Gosu::GP_BUTTON_0
      @player.accelerate
    end
    if Gosu.button_down? Gosu::KB_SPACE
      @lasers.push(Laser.new(@player.angle, @player.x, @player.y))
    end
    @player.move
    @player.collect_stars(@stars)
  end

  def update_objects
    if rand(100) < 4 && @stars.size < 25
      @stars.push(Star.new(@star_anim))
    end

    if rand(100) < 4 && @asteroids.size < 5
      @asteroids.push(Asteroid.new)
    end
    @lasers.reject! do |laser|
      hit_asteroid = laser.hit_asteroid(@asteroids)
      if hit_asteroid
        @crash.play
        @asteroids.delete(hit_asteroid)
      end
      laser.out_of_bounds? || hit_asteroid
    end
    @asteroids.each { |asteroid| asteroid.move }
    @lasers.each { |laser| laser.move}
  end

  def draw_game_screen
    @player.draw
    @stars.each { |star| star.draw }
    @asteroids.each { |asteroid| asteroid.draw }
    @lasers.each { |laser| laser.draw }
    @font.draw_text("Score: #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
  end

  def draw_game_over_screen
    @font.draw_text("Final Score: #{@player.score}", 260, 200, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
    @font.draw_text("ESC to exit", 270, 240, ZOrder::UI, 1.0, 1.0, Gosu::Color::RED)
  end

  def button_down(id)
    if id == Gosu::KB_ESCAPE
      close
    else
      super
    end
  end
end

Tutorial.new.show
