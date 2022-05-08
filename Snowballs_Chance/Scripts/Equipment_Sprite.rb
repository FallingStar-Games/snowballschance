#==============================================================================
# Equipment Sprite
# By Atoa
#==============================================================================
# This script allows you to set equipments that adds sprites that overlaps
# the battler graphics
#
# An type of "Visual Equipment" for battle
#==============================================================================


module Atoa
  # Do not remove or change this line
  Equipment_Sprite = {'Weapon' => {}, 'Armor' => {}}
  # Do not remove or change this line
  
  # Setting of sprites for equipments
  # Equipment_Sprite[Type][ID] = ['Extension', above]
  # Tipo = Equipment Type
  #   'Weapon' for weapons.
  #   'Armor' for armors.
  # ID = Equip ID
  # Extensão = Sufix that must be added to the battler file name.
  #   The graphics must have file name equal the battler graphic file name + extensio
  # above = true/false. If true, the equip sprite stay above the battler sprite,
  #    if false the equip sprite stau bellow the battler sprite.
  #
  #   Ex.:
  #    Equipment_Sprite['Weapon'][3] = ['_steelsword', true]
  #    Equipment_Sprite['Weapon'][4] = ['_mythrilsword', true]
  #    An Actor with battler graphic named '001-Fighter01' using the weapon ID 4
  #    will need an sprite named '001-Fighter01_mythrilsword'.
  #    That way, when equip the weapon ID4 an new graphic will be added.
  #    Actors with battlers without special graphics won't be changed.
  #
  # OBs.: I the actor is using more than one weapon using the script "Two Hands"
  #   or "Equipment Multi Slots", you can add special graphics for the weapons
  #   besides the main, for the 1st weapon besides the first, adds an "1" to 
  #   the file name, for the 2nd adds an "2" an so.
  #   Ex.: 
  #    Equipment_Sprite['Weapon'][3] = ['_steelsword', true]
  #    Equipment_Sprite['Weapon'][4] = ['_mythrilsword', true]
  #    An Actor with battler graphic named 'dude', that uses two weapons
  #    (set on the script 'Two Hands') equips the weapon ID 4 on the 2nd hand.
  #    if you want it to have an special graphic, you will need an file named
  #    'dude_mythrilsword1'
  
  Equipment_Sprite['Weapon'][69] = ['_nice', true]
  Equipment_Sprite['Weapon'][1] = ['_gunaxe', true]
  Equipment_Sprite['Weapon'][2] = ['_cutlass', true]
  Equipment_Sprite['Weapon'][11] = ['_staff', true]
  Equipment_Sprite['Weapon'][13] = ['_whip', true]
  Equipment_Sprite['Weapon'][6] = ['_knife', true]
  Equipment_Sprite['Weapon'][14] = ['_claws', true]
  Equipment_Sprite['Weapon'][15] = ['_knives', true]
  Equipment_Sprite['Weapon'][16] = ['_ladle', true]
  Equipment_Sprite['Weapon'][4] = ['_rapier', true]
  # IMPORTANT:
  # Remember that the graphics are *added* above/bellow the original graphic.
  # The original graphic isn't changed in any way.
  # So you will need to make the extra sprites following the same patterns
  # as the original graphic.
  
end

#==============================================================================
# ** Atoa Module
#==============================================================================
$atoa_script = {} if $atoa_script.nil?
$atoa_script['Atoa Equip Sprite'] = true

#==============================================================================
# ** Sprite_Battler
#------------------------------------------------------------------------------
#  This sprite is used to display the battler.It observes the Game_Character
#  class and automatically changes sprite conditions.
#==============================================================================

class Sprite_Battler < RPG::Sprite
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     viewport : viewport
  #     battler  : battler (Game_Battler)
  #--------------------------------------------------------------------------
  alias initialize_equipsprite initialize
  def initialize(viewport, battler = nil)
    @equips_sprite = []
    @mirage_equip = {} 
    initialize_equipsprite(viewport, battler)
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  alias update_equipsprite update
  def update
    update_equipsprite
    for equip in @equips_sprite
      equip.update
    end
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  alias dispose_equipsprite dispose
  def dispose
    dispose_equipsprite
    equip_sprites_dispose 
  end
  #-------------------------------------------------------------------------
  # * Battler bitmap update
  #--------------------------------------------------------------------------
  alias update_battler_bitmap_equipsprite update_battler_bitmap
  def update_battler_bitmap
    update_battler_bitmap_equipsprite
    if @battler.actor? and (@battler_name != @battler_equip_name or
       @battler_direction != @battler_equip_direction or 
       @battler.equips != @battler_equips)
      @battler_equip_name = @battler_name
      @battler_equip_direction = @battler_direction
      @battler_equips = @battler.equips.dup
      equip_sprites_dispose
      @equips_sprite = set_equip_sprites(self)
    end
  end
  #--------------------------------------------------------------------------
  # * Pose change
  #     n : pose ID
  #--------------------------------------------------------------------------
  alias change_pose_equipsprite change_pose
  def change_pose(n)
    change_pose_equipsprite(n)
    for equip in @equips_sprite
      equip.set_bitmap
      equip.bitmap_update_rect
    end
  end
  #--------------------------------------------------------------------------
  # * Current frame update
  #     forced : forced update flag
  #--------------------------------------------------------------------------
  alias update_current_frame_equipsprite update_current_frame
  def update_current_frame(forced = false)
    update_current_frame_equipsprite(forced)
    for equip in @equips_sprite
      equip.bitmap_update_rect
    end
  end
  #--------------------------------------------------------------------------
  # * Bitmap update for multi graphics battlers
  #--------------------------------------------------------------------------
  alias uptade_battler_multi_bitmap_equipsprite uptade_battler_multi_bitmap
  def uptade_battler_multi_bitmap
    uptade_battler_multi_bitmap_equipsprite
    equip_sprites_dispose
    @equips_sprite = set_equip_sprites(self)
  end
  #--------------------------------------------------------------------------
  # * Get equipment sprites
  #     bt_sprite : original sprite
  #--------------------------------------------------------------------------
  def set_equip_sprites(bt_sprite)
    equips_sprite = []
    if @battler.actor?
      for i in 0...@battler.armors.size
        if Equipment_Sprite['Armor'] != nil and
           Equipment_Sprite['Armor'].include?(action_id(@battler.armors[i]))
          equips_sprite << add_equip_sprite(bt_sprite, 'Armor', 0, action_id(@battler.armors[i]))
        end
      end
      for i in 0...@battler.weapons.size
        if Equipment_Sprite['Weapon'] != nil and
           Equipment_Sprite['Weapon'].include?(action_id(@battler.weapons[i]))
          equips_sprite << add_equip_sprite(bt_sprite, 'Weapon', i, action_id(@battler.weapons[i]))
        end
      end
    end
    return equips_sprite
  end
  #--------------------------------------------------------------------------
  # * Add equipment sprite
  #     bt_sprite : original sprite
  #     kind      : equip type
  #     index     : index
  #     equip     : equip ID
  #--------------------------------------------------------------------------
  def add_equip_sprite(bt_sprite, kind, index, equip)
    dir = Battle_Style == 3 ? set_battler_direction : ''
    set_name_init
    name = set_battler_name + dir
    info = Equipment_Sprite[kind][equip]
    equip_sprite = Equip_Sprite.new(self.viewport, @battler, bt_sprite, name, info, index)
    return equip_sprite
  end
  #--------------------------------------------------------------------------
  # * Dispose equipment sprites
  #--------------------------------------------------------------------------
  def equip_sprites_dispose
    for equip in @equips_sprite
      next if equip.nil?
      equip.dispose
    end
    @equips_sprite.clear
  end
  #--------------------------------------------------------------------------
  # * Start mirage effect
  #--------------------------------------------------------------------------
  alias mirage_init_equipsprite mirage_init
  def mirage_init
    mirage_init_equipsprite
    for mirage in @mirage
      next unless @mirage_equip[mirage].nil?
      @mirage_equip[mirage] = set_equip_sprites(self)
    end
  end
  #--------------------------------------------------------------------------
  # * Update mirage graphic
  #     img : mirage graphic
  #--------------------------------------------------------------------------
  alias mirage_equipsprite mirage
  def mirage(img)
    mirage_equipsprite(img)
    if @mirage_equip[img] != nil
      for equip in @mirage_equip[img]
        equip.update
        equip.bitmap_update_rect
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Set mirage color
  #     img : mirage graphic
  #--------------------------------------------------------------------------
  alias set_image_color_equipsprite set_image_color
  def set_image_color(img)
    set_image_color_equipsprite(img)
    if @mirage_equip[img] != nil
      for equip in @mirage_equip[img]
        equip.color = img.color
        equip.opacity = img.opacity
        equip.z = img.z - 1
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Delete mirage
  #     img : mirage sprite
  #--------------------------------------------------------------------------
  alias delete_mirage_equipsprite delete_mirage
  def delete_mirage(img)
    if @mirage_equip[img] != nil
      for equip in @mirage_equip[img]
        equip.dispose
      end
      @mirage_equip[img] = nil
    end
    delete_mirage_equipsprite(img)
  end
end

#==============================================================================
# ** Equip_Sprite
#------------------------------------------------------------------------------
#  This sprite is used to display the battler equipment
#==============================================================================

class Equip_Sprite < RPG::Sprite
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     viewport     : viewport
  #     battler      : battler (Game_Battler)
  #     sprite       : battler sprite
  #     battler_name : battler filename
  #     sprite_inf   : equip sprite info
  #     index        : equip index
  #--------------------------------------------------------------------------
  def initialize(viewport, battler, sprite, battler_name, sprite_info, index = 0)
    super(viewport)
    @sprite = sprite
    @battler = battler
    @battler_name = battler_name
    @sprite_name = sprite_info[0]
    @sprite_above = sprite_info[1]
    @equip_index = index
    set_bitmap
    update
    bitmap_update_rect
  end
  #--------------------------------------------------------------------------
  # * Set bitmap
  #--------------------------------------------------------------------------
  def set_bitmap
    @sprite.set_name_init
    @pattern = @sprite.pattern
    pattern = (@sprite.name_init == '%' ? '_' + @pattern.to_s : '')
    if @equip_index == 0
      begin; self.bitmap = RPG::Cache.battler(@battler_name + pattern + @sprite_name, 0)
      rescue; end
    else
      begin; self.bitmap = RPG::Cache.battler(@battler_name + pattern + @sprite_name + @equip_index.to_s, 0)
      rescue; end
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    set_bitmap if @pattern != @sprite.pattern
    self.x = @sprite.actual_x_position
    self.y = @sprite.actual_y_position
    self.z = @sprite.z + (@sprite_above ? 1 : -1)
    self.ox = @sprite.ox
    self.oy = @sprite.oy
    self.zoom_x = @sprite.zoom_x
    self.zoom_y = @sprite.zoom_y
    self.mirror = @sprite.mirror
    self.opacity = @sprite.opacity
    self.blend_type = @sprite.blend_type
    self.color.alpha = @sprite.color.alpha
    self.color = @sprite.color
  end
  #--------------------------------------------------------------------------
  # * Update bitmap rectangle
  #--------------------------------------------------------------------------
  def bitmap_update_rect
    self.src_rect.set(@sprite.offset_x, @sprite.offset_y, @sprite.frame_width, @sprite.frame_height)
  end
end