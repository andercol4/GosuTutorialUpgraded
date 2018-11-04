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

    @player = Player.new
    @player.warp(320, 240)

    @star_anim = Gosu::Image.load_tiles("media/star.png", 25, 25)
    @stars = Array.new
    @asteroids = Array.new
    @font = Gosu::Font.new(20)

  end

  def update
    unless @game_over
      if Gosu.button_down? Gosu::KB_LEFT or Gosu::button_down? Gosu::GP_LEFT
        @player.turn_left
      end
      if Gosu.button_down? Gosu::KB_RIGHT or Gosu::button_down? Gosu::GP_RIGHT
        @player.turn_right
      end
      if Gosu.button_down? Gosu::KB_UP or Gosu::button_down? Gosu::GP_BUTTON_0
        @player.accelerate
      end
      @player.move
      @player.collect_stars(@stars)
      @game_over = @player.crash(@asteroids)


      if rand(100) < 4 && @stars.size < 25
        @stars.push(Star.new(@star_anim))
      end

      if rand(100) < 4 && @asteroids.size < 5
        @asteroids.push(Asteroid.new)
      end
      @asteroids.each { |asteroid| asteroid.move }
      @game_over = @player.crash(@asteroids)
    end
  end

  def draw
    unless @game_over
      @background_image.draw(0, 0, ZOrder::BACKGROUND)
      @player.draw
      @stars.each { |star| star.draw }
      @asteroids.each { |asteroid| asteroid.draw }
      @font.draw_text("Score: #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
    else
      @font.draw_text("Final Score: #{@player.score}", 260, 200, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
      @font.draw_text("ESC to exit", 270, 240, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
    end

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
