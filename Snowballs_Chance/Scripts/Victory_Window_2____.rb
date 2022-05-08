#==============================================================================
# Victory Window 2
# by KGC
# Modified by Atoa, to work with ACBS
# and then heavily edited by shinyjiggly
#
#NOTE: this needs to be modified to also have stat increases
#
#===============================================================================
# This scripts changes the victory window
# 
# Don't use with others 'Victory Windows' script.
#==============================================================================
=begin
class Window_Base < Window

  #------------------------------------------------------
  # Draw Skill Name
  #-----------------------------------------------------
  
  def draw_skill_name(skill, x, y)
    if skill == nil
      return
    end
    #icon = RPG::Cache.icon(skill.icon_name)
    bitmap = RPG::Cache.icon(skill.icon_name)
    self.contents.blt(x, y + 4, bitmap, Rect.new(0, 0, 24, 24))
    self.contents.font.color = normal_color
    self.contents.font.size = 20
    self.contents.draw_text(x + 28, y, 212, 32, skill.name)
  end

end 

#==============================================================================
# ** Window_BattleStatus
#------------------------------------------------------------------------------
#  This window displays the status of all party members on the battle screen.
#==============================================================================
class Window_BattleStatus < Window_Base
  #--------------------------------------------------------------------------
  attr_reader   :level_up_flags
  
end

#==============================================================================
# ** Window_BattleResult
#------------------------------------------------------------------------------
#  This window displays amount of gold and EXP acquired at the end of a battle.
#==============================================================================

class Window_BattleResult < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     exp       : EXP
  #     gold      : amount of gold
  #     treasures : treasures
  #--------------------------------------------------------------------------
  def initialize(exp, gold, treasures)
    @exp = exp
    @gold = gold
    @treasures = treasures
    @level_up_flags = [false, false, false, false, false]
    @gold_window = Window_Gold.new
    @gold_window.x = 480
    @gold_window.back_opacity = Base_Opacity
    @gold_window.z = 4100
    super(0, 0, 640, 480)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.back_opacity = Base_Opacity
    self.visible = false
    self.z = 4000
  end
  

  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose
    @gold_window.dispose
    super
  end
  #--------------------------------------------------------------------------
  # * Window visibility
  #     n : opacity
  #--------------------------------------------------------------------------
  def visible=(n)
    @gold_window.visible = n
    super
  end
  #--------------------------------------------------------------------------
  # * Set Level Up Flag
  #     actor_index : actor index
  #--------------------------------------------------------------------------
  def level_up(actor_index)
    @level_up_flags[actor_index] = true
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #     last_level : last level
  #--------------------------------------------------------------------------
  def refresh(last_level = 0)
    if self.y != 0
      self.contents = Bitmap.new(608, 450)
      #self.contents = Bitmap.new(608, 288)
      self.y = 0
      self.height = 440
      self.contents.font.size = 20
    end
    self.contents.clear
    x = 0
    self.contents.draw_text(x, 0, 200, 32, 'Loot obtained:')
    
    #draw given exp
    self.contents.font.color = normal_color
    cx = contents.text_size(@exp.to_s).width
    self.contents.draw_text(x, 24, cx+12, 32, "+" + @exp.to_s)
    x += cx + 18
    
    #draw "exp"
    self.contents.font.color = system_color
    cx = contents.text_size('EXP').width
    self.contents.draw_text(x, 24, 64, 32, 'EXP')
    x += cx + 16
    self.contents.font.color = normal_color
    cx = contents.text_size(@gold.to_s).width
    self.contents.draw_text(x, 24, cx+12, 32, "+" + @gold.to_s)
    x += cx + 18
    self.contents.font.color = system_color
    self.contents.draw_text(x, 24, 128, 32, $data_system.words.gold)
    x = 0; y = 48
    
    #treasure display
    for item in @treasures
      draw_item_name(item, x, y)
      y += 24
      if y == 120
        x += 204; y = 24
        
        if x == 408
        y = 48
        end
      
      end
    end
    
    self.contents.font.size = 20
    self.contents.draw_text(0, 130, 640, 32, '|-----------Level-------------------------------|------New Skills--------|')
    y = 160
    
    for i in 0...$game_party.actors.size
      actor = $game_party.actors[i]
      self.contents.font.color = system_color
      charx = 0
      self.contents.draw_text(charx, y, 120, 32, actor.name)
      charx += 90
      self.contents.font.color = normal_color
      self.contents.draw_text(charx, y, 48, 32, '| Lv')
      charx += 30 #110
      self.contents.draw_text(charx, y, 32, 32, actor.level.to_s, 2)
      #self.contents.draw_text(0, y + 24, 48, 32, $data_system.words.hp)
      #self.contents.draw_text(112, y + 24, 48, 32, $data_system.words.sp)

      #self.contents.draw_text(0, y + 24, 80, 32, actor.maxhp.to_s, 2)
      #self.contents.draw_text(112, y + 24, 80, 32, actor.maxsp.to_s, 2)
      charx += 50 #160
      self.contents.font.color = system_color
      self.contents.draw_text(charx, y, 80, 32, 'EXP')
      self.contents.font.color = normal_color
      charx += 10 #170
      self.contents.draw_text(charx, y, 84, 32, actor.exp_s, 2)
      if @level_up_flags[i]
      charx = 270 
        self.contents.font.color = text_color(6)
        self.contents.draw_text(charx, y , 144, 32, 'Leveled up!')
        actor_class = $data_classes[actor.class_id]
        @learn_skills = []
        for j in 0...actor_class.learnings.size
          learn_skill = actor_class.learnings[j]
          if actor.level >= learn_skill.level && last_level[i] < learn_skill.level
            @learn_skills << learn_skill.skill_id
          end
        end

        unless @learn_skills == []
          self.contents.font.size = 20
          self.contents.font.color = normal_color
          
          #skill y is Y plus
          #font size minus at least as many skills as there are times ten
          sy = y + (24 - [@learn_skills.size - 1, 2].min * 12)
          #oh crud for loop hell...
          for j in 0...[@learn_skills.size, 2].min 
            skill = $data_skills[@learn_skills[j]] #"skill" is the skill learned
            
            draw_skill_name(skill, 444, sy - 8 + j * 24)
            
            #icon = RPG::Cache.icon(skill.icon_name) #"icon is the icon for that skill"
            #it will go over here in this rectangle
            #which is 424 px to the side, 
            #down to skill y plus iteration *24 for vertical list,
            #and 20x20 (changed to 24x24 for sanity)
            #dest_rect = Rect.new(424, sy + j * 24, 24, 24)
            #src_rect = Rect.new(0, 0, 24, 24)
            #here's the stretcher, puts the icon in the rectangle area
            #self.contents.stretch_blt(dest_rect, icon, src_rect)
            #(item,x,y)
            #self.contents.draw_text(444, sy - 8 + j * 24, 180, 32, skill.name)
          end

          self.contents.font.size = 20
        end

      else
        charx = 280 
        self.contents.font.color = system_color
        self.contents.draw_text(charx, y , 80, 32, 'Next') #self.contents.draw_text(208, y + 24, 80, 32, 'Next')
        self.contents.font.color = normal_color
        charx += 10 #290
        self.contents.draw_text(charx, y, 84, 32, actor.next_rest_exp_s, 2)
      end
      y += 24
    end
  end
end

#==============================================================================
# ** Scene_Battle 
#------------------------------------------------------------------------------
#  This class performs battle screen processing.
#==============================================================================

class Scene_Battle
  #--------------------------------------------------------------------------
  # * Show result window
  #--------------------------------------------------------------------------
  alias set_result_window_KGC_ResultAlter set_result_window
  def set_result_window
    actor_last_level = []
    for i in 0...$game_party.actors.size
      actor_last_level[i] = $game_party.actors[i].level
    end
    set_result_window_KGC_ResultAlter
    for i in 0...$game_party.actors.size
      if @status_window.level_up_flags[i]
        @result_window.level_up(i)
      end
    end
    @result_window.refresh(actor_last_level)
  end
end
=end