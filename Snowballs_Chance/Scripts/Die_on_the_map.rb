#==============================================================================
#
#      HERETIC's MAP DEATH
#      Version 1.0
#      Tuesday, May 29th, 2012
#
#==============================================================================
#
#  ---  Overview  ---
#
#  This script will bring up the Game Over screen any time everyone in your
#  party Dies, due to Poison or other Damage Slip Inflicted States.  It can
#  be turned On and Off with a Game Switch, or simply set to true for being
#  on the entire time.
#
#
#  -----  Features  -----
#
#  - Customizable
#  - Other Animations still take place on Map Screen
#
#  ---  Instructions  ---
#
#  Change GAME SWITCH to ON to allow Game Over when everyone in your Party
#  has died at any time for any reason.  It can be turned off for places
#  that wouldnt make sense to Game Over if Party Dead, like In Town.
#
#  Switch Number can be changed to whatever Game Switch Number you want.
#
#  ---  Options  ---
#
#  WINDOW_DELAY - How long to wait between Death and Msg, and Msg and Game Over.
#  
#
=begin
class Party_Dead < Window_Base
  
  # ---  OPTIONS  ---
  
  ALLOW_MAP_DEATH = true          # Turn this GAME SWITCH to ON or OFF, or true
  WINDOW_DELAY_IN_FRAMES = 30   # Delay between Death, Window, and Game Over
  OPACITY_CHANGE_PER_FRAME = 35 # Allows Your Party Is Dead Window to Fade
  
  # ---  END OPTIONS  ----
  
  def initialize(x, y, width, height)
    super(x, y, width, height)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.opacity = 0
    self.back_opacity = 0
    self.contents_opacity = 0
    self.visible = true
    self.active = true
    #@id = id
    refresh
    @faded_in = false
  end
  
  def refresh
    # Setup the Window Options
    self.contents.clear
    self.contents.font.color = normal_color
    
    # If this Text is Adjusted, Window needs to be Adjusted 
    # (x,  y, width, height, align =(0 = left, 1 = center, 2 = right))
    self.contents.draw_text(20, 14, 180, 32, "Your Party is Dead!", 1)
  end
  
  def update
    super
    if not @faded_in
      if self.opacity < 255
        self.opacity += Party_Dead::OPACITY_CHANGE_PER_FRAME
        self.back_opacity += Party_Dead::OPACITY_CHANGE_PER_FRAME
        self.contents_opacity += Party_Dead::OPACITY_CHANGE_PER_FRAME
      else
        @faded_in = true
      end
    elsif not @fade_out
      # If B or C buttons were pressed
      if Input.trigger?(Input::B) or Input.trigger?(Input::C)
          @fade_out = true          
      end
    elsif @fade_out and not @faded_out
      if self.opacity > 0
        self.opacity -= Party_Dead::OPACITY_CHANGE_PER_FRAME
        self.back_opacity -= Party_Dead::OPACITY_CHANGE_PER_FRAME
        self.contents_opacity -= Party_Dead::OPACITY_CHANGE_PER_FRAME
      else
        @faded_out = Graphics.frame_count
      end
    elsif @faded_out and 
          Graphics.frame_count > @faded_out + Party_Dead::WINDOW_DELAY_IN_FRAMES
      # Call Game Over Scene
      $scene = Scene_Gameover.new
      # Dispose of Window
      self.dispose      
    end
  end
end

class Game_Party
  
  #--------------------------------------------------------------------------
  # * Slip Damage Check (for map)
  #--------------------------------------------------------------------------
  def check_map_slip_damage
    for actor in @actors
      if actor.hp > 0 and actor.slip_damage?
        actor.hp -= [actor.maxhp / 100, 1].max
        if actor.hp == 0
          $game_system.se_play($data_system.actor_collapse_se)
        end
        $game_screen.start_flash(Color.new(255,0,0,128), 4)
        # This had to be removed
        #$game_temp.gameover = $game_party.all_dead?
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * Determine Everyone is Dead
  #--------------------------------------------------------------------------
  def all_dead?
    # If number of party members is 0
    if $game_party.actors.size == 0
      return false
    end
    # If an actor is in the party with 0 or more HP
    for actor in @actors
      if actor.hp > 0
        return false
      end
    end
 
    if $scene.is_a?(Scene_Battle) or 
       ($scene.is_a?(Scene_Map) and Party_Dead::ALLOW_MAP_DEATH)
      # All members dead
      return true
    else 
      # They are dead but not the right scene
      return false
    end
  end
end

class Game_Map
  unless self.method_defined?('map_screen_death_update')
    alias map_screen_death_update update 
  end
  
  def update 
    # If Game Switch is ON or it is set to true in the Options
    if allow_map_death?
      # If the whole party died 
      if $game_party.all_dead? or $game_actors[1].dead?
        
        # If the Player isnt being prevented from Moving with a Repeating Wait
        if not @died_time

          # Fades to Red and maintains the other color values
          tone = $game_screen.tone.clone
          tone.to_s.gsub(/([0-9\.]+)/) {@r = $1.to_f,
                                        @g = $2.to_f,
                                        @b = $3.to_f,
                                        @grey = $4.to_f}

          new_tone = Tone.new(80.0,@r[1],@r[2],@r[3])
          $game_screen.start_tone_change(new_tone, 200)

          # Prevent Interpreter from being Triggered by Player
          $game_temp.ignore_interpreter = true
          
          # Disable Menu Access
          $game_system.menu_disabled = true
          # Play Actor Collapse Sound Effect from Game Settings
          $game_system.se_play($data_system.actor_collapse_se) 
          # Create a New Move Route and Repeat It
          dead_route = RPG::MoveRoute.new
          dead_route.repeat = true
          dead_route.skippable = false
        
          # Push on a Wait Command on to the MoveRoute for stopping the Player
          dead_route.list.unshift(RPG::MoveCommand.new(15, [20]))
          # Force the Move Route to the Cat Actor IF it was a Valid Direction
          $game_player.force_move_route(dead_route)

          # Frame Counter when Everyone was found Dead
          @died_time = Graphics.frame_count
        end
          
        # If the Window hasnt been Created      
        if !@dead_window and 
            Graphics.frame_count > @died_time + Party_Dead::WINDOW_DELAY_IN_FRAMES
          if $game_player.screen_y > 240
            @dead_window = Party_Dead.new(220, 20, 250, 96)
          else
            @dead_window = Party_Dead.new(220, 370, 250, 96)
          end
        elsif @dead_window
          @dead_window.update
        end
      end
    end
    # Run Original 
    map_screen_death_update    
  end 
  
  #----------------------------------------------------------------------------
  # * Checks for a Game Switch Number, or just true
  #----------------------------------------------------------------------------

  def allow_map_death?
    # If the Option is looking for a Game Switch
    if Party_Dead::ALLOW_MAP_DEATH.is_a?(Integer)
      # Return the Value of the Game Switch
      return $game_switches[Party_Dead::ALLOW_MAP_DEATH]
    else
      # Return Value of the Constant (true) when not using a Game Switch
      return Party_Dead::ALLOW_MAP_DEATH
    end
  end    
end

class Interpreter
  def running?
    # Does the Interpreter need to be Ignored - Prevents last step on triggers.
    return true if $game_temp.ignore_interpreter
    # Original
    return @list != nil
  end
end

class Game_Temp
  attr_accessor :ignore_interpreter
  
  unless self.method_defined?('die_initialize')
    alias die_initialize :initialize
  end
  
  def initialize
    # Run the Original
    die_initialize
    # Create the New Variable
    @ignore_interpreter = false
  end
end
=end