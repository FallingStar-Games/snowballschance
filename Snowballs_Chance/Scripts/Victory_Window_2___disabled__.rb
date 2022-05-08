#==============================================================================
# Victory Window 2
# by KGC
# Modified by Atoa, to work with ACBS
#===============================================================================
# This scripts changes the victory window
# 
# Don't use with others 'Victory Windows' script.
#==============================================================================
=begin
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
    super(0, 0,640, 320)
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
      self.contents = Bitmap.new(608, 288)
      self.y = 0
      self.height = 320
    end
    self.contents.clear
    x = 0
    self.contents.font.color = normal_color
    cx = contents.text_size(@exp.to_s).width
    self.contents.draw_text(x, 0, cx, 32, @exp.to_s)
    x += cx + 4
    self.contents.font.color = system_color
    cx = contents.text_size('EXP').width
    self.contents.draw_text(x, 0, 64, 32, 'EXP')
    x += cx + 16
    self.contents.font.color = normal_color
    cx = contents.text_size(@gold.to_s).width
    self.contents.draw_text(x, 0, cx, 32, @gold.to_s)
    x += cx + 4
    self.contents.font.color = system_color
    self.contents.draw_text(x, 0, 128, 32, $data_system.words.gold)
    x = 0; y = 24
    for item in @treasures
      draw_item_name(item, x, y)
      y += 24
      if y == 96
        x += 224; y = 24
      end
    end
    y = 96
    for i in 0...$game_party.actors.size
      actor = $game_party.actors[i]
      self.contents.font.color = system_color
      self.contents.draw_text(112, y, 48, 32, 'Nível')
      self.contents.draw_text(0, y + 24, 48, 32, $data_system.words.hp)
      self.contents.draw_text(112, y + 24, 48, 32, $data_system.words.sp)
      self.contents.font.color = normal_color
      self.contents.draw_text(0, y, 120, 32, actor.name)
      self.contents.draw_text(160, y, 32, 32, actor.level.to_s, 2)
      self.contents.draw_text(0, y + 24, 80, 32, actor.maxhp.to_s, 2)
      self.contents.draw_text(112, y + 24, 80, 32, actor.maxsp.to_s, 2)
      self.contents.font.color = system_color
      self.contents.draw_text(208, y, 80, 32, 'EXP')
      self.contents.font.color = normal_color
      self.contents.draw_text(256, y, 84, 32, actor.exp_s, 2)
      if @level_up_flags[i]
        self.contents.font.color = text_color(6)
        self.contents.draw_text(208, y + 24, 144, 32, 'Leveled up!')
        actor_class = $data_classes[actor.class_id]
        @learn_skills = []
        for j in 0...actor_class.learnings.size
          learn_skill = actor_class.learnings[j]
          if actor.level >= learn_skill.level && last_level[i] < learn_skill.level
            @learn_skills << learn_skill.skill_id
          end
        end
        unless @learn_skills == []
          self.contents.font.size = Font.default_size - 4
          self.contents.font.color = text_color(3)
          self.contents.draw_text(344, y + 4, 64, 32, 'Nova', 1)
          self.contents.draw_text(344, y + 24, 64, 32, 'Habilidade', 1)
          self.contents.font.color = normal_color
          sy = y + (24 - [@learn_skills.size - 1, 2].min * 10)
          for j in 0...[@learn_skills.size, 2].min
            skill = $data_skills[@learn_skills[j]]
            icon = RPG::Cache.icon(skill.icon_name)
            dest_rect = Rect.new(424, sy + j * 24, 20, 20)
            src_rect = Rect.new(0, 0, 24, 24)
            self.contents.stretch_blt(dest_rect, icon, src_rect)
            self.contents.draw_text(444, sy - 8 + j * 24, 180, 32, skill.name)
          end
          self.contents.font.size = Font.default_size
        end
      else
        self.contents.font.color = system_color
        self.contents.draw_text(208, y + 24, 80, 32, 'Próx.')
        self.contents.font.color = normal_color
        self.contents.draw_text(256, y + 24, 84, 32, actor.next_rest_exp_s, 2)
      end
      y += 48
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