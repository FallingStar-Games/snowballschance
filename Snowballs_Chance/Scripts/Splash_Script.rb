#==============================================================================
# ** Splash Script
#------------------------------------------------------------------------------
# - Coded by :rm-rf
# - Original by :Lambchops
# - Version :1.1
# - 24/02/2010
#------------------------------------------------------------------------------
# * How to Use:
# - Just add more filenames to SplashFiles = ['filename', ..., ...]
# - and configure the speed of loading each images.
# - That's it ;o
#==============================================================================

module SSConfig
  #----------------------------------------------------------------------------
  # * Splash Files
  #     :folder- :Graphics/Picture
  #     :config- :['filename', 'filename', ..., ...]
  #----------------------------------------------------------------------------
  SplashFiles = ['company_logo_dark', 'obligitoryfmodsplash','fontwarningb']
  #----------------------------------------------------------------------------
  # * Splash Speed / Wait
  #     :the speed of transition, 2-4 is ideal
  #     :wait is for how long the image will show for
  #----------------------------------------------------------------------------
  SplashSpeed = 5
  SplashWait = 30
  #----------------------------------------------------------------------------
  # * Play Music During Splash?
  #     :config- :true / false
  #     :do you want to play music during the splash?
  #----------------------------------------------------------------------------
  PlayMusic = false
  #----------------------------------------------------------------------------
  # * Music File
  #     :folder- :Audio/BGM
  #     :use the filename for the audio. (dont need the extention i suppose)
  #----------------------------------------------------------------------------
  MusicFile = ''
end

class Scene_Splash
  #----------------------------------------------------------------------------
  # * Main
  #----------------------------------------------------------------------------
  def main
    # Setup Variables
    main_variable
    # Setup Sprites
    main_sprite
    # Setup Audio
    main_audio
    # Execute transition
    Graphics.transition
    # Run main loop
    loop do
      # Update game screen
      Graphics.update
      # Update input information
      Input.update
      # Frame update
      update
      # Abort loop if screen is changed
      break if $scene != self
    end
    # Prepare for transition
    Graphics.freeze
    # Dispose sprites
    @sprites.each {|i| i.dispose}
  end   
  #----------------------------------------------------------------------------
  # * Main: Variable
  #----------------------------------------------------------------------------
  def main_variable
    # Setup important variables
    @index = 0
    @hide = false
    @show = true
    @opacity = 0
    @wait = 0
  end
  #----------------------------------------------------------------------------
  # * Main: Sprite
  #----------------------------------------------------------------------------
  def main_sprite
    # Setup array
    @sprites = []
    # Make sprites
    SSConfig::SplashFiles.each_with_index do |filename, i|
      @sprites[i] = Sprite.new
      @sprites[i].bitmap = RPG::Cache.picture(filename)
      @sprites[i].opacity = 0
    end
  end
  #----------------------------------------------------------------------------
  # * Main: Audio
  #----------------------------------------------------------------------------
  def main_audio
    # Play BGM
    Audio.bgm_play('Audio/BGM/' + SSConfig::MusicFile) if SSConfig::PlayMusic
  end
  #----------------------------------------------------------------------------
  # * Frame Update
  #----------------------------------------------------------------------------
  def update
    # If input triggered
#=begin
    if Keys.trigger?($keyboard["select"]) || Keys.trigger?($keyboard["cancel"])
      #Input.trigger?(Input::C) || Input.trigger?(Input::B)
      # Switch to Title
      Audio.bgm_fade(1000) if SSConfig::PlayMusic
      $scene = Scene_Title.new
    end
#=end
    # Do Hide/Show images
    process_transition
  end
  #----------------------------------------------------------------------------
  # * Process Transition
  #----------------------------------------------------------------------------
  def process_transition
    # Fade In
    if @show
      # Increase Opacity
      @opacity += SSConfig::SplashSpeed
      # If Opacity's at maximum
      if @opacity > 255
        # Hide images
        @show = false
        @opacity = 255
        @wait = SSConfig::SplashWait
      end
    end
    # Wait for a bit
    if @wait > 0
      # Decrease Wait Count
      @wait -= 1
      # Done waiting
      if @wait <= 0
        # Fade out
        @hide = true
        # Reset wait
        @wait = 0
      end
    end
    # Fade Out
    if @hide
      # Decrease Opacity
      @opacity -= SSConfig::SplashSpeed
      # If Opacity's at minimum
      if @opacity < 0
        # Show images
        @hide = false
        @show = true
        @opacity = 0
        # Change Index
        @index += 1
      end
    end
    # Branch by index
    case @index
    when 0...SSConfig::SplashFiles.size
      # Set Opacity
      @sprites[@index].opacity = @opacity
    when (SSConfig::SplashFiles.size)
      # Switch to Title
      Audio.bgm_fade(1000) if SSConfig::PlayMusic
      $scene = Scene_Title.new
    end
  end
end