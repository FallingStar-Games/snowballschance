#==============================================================================
# Cross Reference System (XP)
# by Shaz
# Version 1.00
#==============================================================================
# Place script into new slot above Main
# F9 debug now offers a choice between the old debug and the Cross Reference
# system
#
# May not work if you have other scripts that modify the Scene_Map.call_debug
# method
#
#==============================================================================
# This is a development tool and should be removed prior to releasing your game
# Do not repost this script.  Link back to original thread only:
# https://forums.rpgmakerweb.com/index.php?threads/cross-reference-script-xp.94371/
#==============================================================================

#=begin
module XRef
  VAREXP = /\\v\[(\d+)\]/i
   
  class EventRef
    def initialize(evt_id, evt_name, evt_page, evt_line)
      @evt_id = evt_id
      @evt_name = evt_name
      @evt_page = evt_page
      @evt_line = evt_line
    end
    attr_accessor :evt_id   # only for map events
    attr_accessor :evt_name # only for map events
    attr_accessor :evt_page # only for map and troop events
    attr_accessor :evt_line # only for map, troop and common events
  end # class EventRef
 
  class Reference
    def initialize(obj_type, obj_id, src_type, src_id, evt, ref, seq)
      @obj_type = obj_type
      @obj_id = obj_id
      @src_type = src_type
      @src_id = src_id
      @evt = evt
      @ref = ref
      @seq = seq
    end
    attr_accessor :obj_type   # referenced object - :switch, :variable, etc
    attr_accessor :obj_id     # object id from database, or variable/switch id
    attr_accessor :src_type   # referencing object type - :actor, :map, etc
    attr_accessor :src_id     # referencing object id - actor id, map id, etc
    attr_accessor :evt        # event info
    attr_accessor :ref        # type of reference (command code or field)
    attr_accessor :seq        # sequence within reference
  end # class Reference
   
  class References
    def initialize
      @references = []
    end
   
    def add(ref)
      @references.push(ref)
    end
   
    def refs
      @references
    end
  end # class References
 
  class ReferencedObjects
    def initialize
      @objects = Hash.new { |hash, key| hash[key] = References.new }
    end
   
    def add(ref)
      @objects[ref.obj_id].add(ref)
    end
   
    def ids
      @objects.keys
    end
   
    def xrefs(id)
      @objects[id].refs
    end
  end # class ReferencedObjects
 
  class CrossReferences
    def initialize
      @referenced_objects = Hash.new { |hash, key| hash[key] = ReferencedObjects.new }
    end
   
    def add(ref)
      @referenced_objects[ref.obj_type].add(ref)
      prttxt = sprintf('%s^%d^%s^', XRef.data_title(ref.obj_type), ref.obj_id,
        XRef.obj_name(ref.obj_type, ref.obj_id))
      prttxt += sprintf('%s^%d^%s^', XRef.data_title(ref.src_type), ref.src_id,
        XRef.obj_name(ref.src_type, ref.src_id))
      if ref.evt && ref.evt.evt_id
        prttxt += sprintf('EV%03d^%s^', ref.evt.evt_id, ref.evt.evt_name)
      else
        prttxt += sprintf('^^')
      end
      if ref.evt
        prttxt += sprintf('%s^%s^', ref.evt.evt_page.to_s, ref.evt.evt_line.to_s)
      else
        prttxt += sprintf('^^')
      end
      prttxt += sprintf('%s', XRef.command(ref.ref))
      $xref_file.puts prttxt
    end
   
    def xrefs(type, id)
      @referenced_objects[type].xrefs(id)
    end
   
    def xref_ids(type)
      @referenced_objects[type].ids
    end
   
    def xref_types
      @referenced_objects.keys
    end
  end # class CrossReferences
 
  #--------------------------------------------------------------------------
  # * XRef Builder
  #--------------------------------------------------------------------------
  def self.data_sources(sym)
    src =  {:switches       =>      $data_system.switches,
            :variables      =>      $data_system.variables,
            :common_events  =>      $data_common_events,
            :actors         =>      $data_actors,
            :classes        =>      $data_classes,
            :skills         =>      $data_skills,
            :items          =>      $data_items,
            :weapons        =>      $data_weapons,
            :armors         =>      $data_armors,
            :enemies        =>      $data_enemies,
            :troops         =>      $data_troops,
            :states         =>      $data_states,
            :animations     =>      $data_animations,
            :system         =>      $data_system,
            :maps           =>      $data_mapinfos}
    return src[sym]
  end
     
  def self.data_title(sym)
    title = {:switches       =>      'Switch',
             :variables      =>      'Variable',
             :common_events  =>      'Common Event',
             :actors         =>      'Actor',
             :classes        =>      'Class',
             :skills         =>      'Skill',
             :items          =>      'Item',
             :weapons        =>      'Weapon',
             :armors         =>      'Armor',
             :enemies        =>      'Enemy',
             :troops         =>      'Troop',
             :states         =>      'State',
             :animations     =>      'Animation',
             :system         =>      'System',
             :maps           =>      'Map'}
    return title[sym]
  end
   
  def self.command(code)
    codes =  {101 => 'Show Text',
              401 => 'Show Text', # continuation
              102 => 'Show Choices',
              103 => 'Input Number',
              105 => 'Button Input Processing',
              111 => 'Conditional Branch',
              117 => 'Call Common Event',
              121 => 'Control Switches',
              122 => 'Control Variables',
              125 => 'Change Gold',
              126 => 'Change Items',
              127 => 'Change Weapons',
              128 => 'Change Armor',
              129 => 'Change Party Member',
              201 => 'Transfer Player',
              202 => 'Set Event Location',
              207 => 'Show Animation',
              231 => 'Show Picture',
              232 => 'Move Picture',
              301 => 'Battle Processing',
              302 => 'Shop Processing',
              605 => 'Shop Processing', # continuation
              303 => 'Name Input Processing',
              311 => 'Change HP',
              312 => 'Change SP',
              313 => 'Change State',
              314 => 'Recover All',
              315 => 'Change EXP',
              316 => 'Change Level',
              317 => 'Change Parameters',
              318 => 'Change Skills',
              319 => 'Change Equipment',
              320 => 'Change Name',
              321 => 'Change Class',
              322 => 'Change Actor Graphic',
              331 => 'Change Enemy HP',
              332 => 'Change Enemy SP',
              333 => 'Change Enemy State',
              336 => 'Enemy Transform',
              337 => 'Show Battle Animation',
              338 => 'Deal Damage',
              339 => 'Force Action',
              509 => 'Set Move Route',
              :condition => 'Condition',
              :name => 'Name',
              :cls => 'Class',
              :equips => 'Equips',
              :learnings => 'Learnings',
              :description => 'Description',
              :animations => 'Animation',
              :common_events => 'Common Event',
              :states => 'State',
              :drop_items => 'Drop Items',
              :action_pattersn => 'Action Patterns',
              :member => 'Members',
              :encounters => 'Encounters',
              :starting_members => 'Starting Members',
              :plus_state => 'Add State',
              :minus_state => 'Remove State',
              :guard_state => 'Guard State'
             }
    return codes.has_key?(code) ? codes[code] : code.to_s
  end
   
  def self.obj_name(obj_type, id)
    case obj_type
    when :system
      'Party Members'
    when :switches, :variables
      data_sources(obj_type)[id]
    else
      #data_sources(obj_type)[id] ? data_sources(obj_type)[id].name : 'a'
    end
  end
 
  def self.obj_types
    @cross_references.xref_types
  end
   
  def self.refs(obj_type, obj_id)
    @cross_references.xrefs(obj_type, obj_id)
  end
 
  def self.load_xrefs
    return if !@cross_references.nil?
     
    $xref_file = File.open('Xrefs.txt', 'w')
   
    @cross_references = CrossReferences.new
   
    $data_mapinfos        = load_data("Data/MapInfos.rxdata")
   
    $data_actors.compact.each         {|actor|  build_actor_xrefs(actor)}
    $data_classes.compact.each        {|cls|    build_class_xrefs(cls)}
    $data_skills.compact.each         {|skill|  build_skill_xrefs(skill)}
    $data_items.compact.each          {|item|   build_item_xrefs(item)}
    $data_weapons.compact.each        {|weapon| build_weapon_xrefs(weapon)}
    $data_armors.compact.each         {|armor|  build_armor_xrefs(armor)}
    $data_enemies.compact.each        {|enemy|  build_enemy_xrefs(enemy)}
    $data_troops.compact.each         {|troop|  build_troop_xrefs(troop)}
    $data_states.compact.each         {|state|  build_state_xrefs(state)}
    $data_common_events.compact.each  {|evt|    build_common_event_xrefs(evt)}
    build_system_xrefs
     
    Dir.glob('Data/Map???.rxdata').each {|filename| build_map_xrefs(filename)}
   
    $xref_file.close
  end
   
  def self.save(obj_type, obj_id, ref = @cmd_code, seq = nil)
    if @evt_id || @evt_page || @evt_line
      evt = EventRef.new(@evt_id, @evt_name, @evt_page, @evt_line)
    else
      evt = nil
    end
    xref = Reference.new(obj_type, obj_id, @src_type, @src_id, evt, ref, seq)
    @cross_references.add(xref)
  end
   
  def self.scan_db_text(text, ref = @cmd_code)
    seq = 0
    text.scan(VAREXP).flatten.map {|val| val.to_i}.each do |var|
      save(:variables, var, ref, seq)
      seq += 1
    end
  end
   
  def self.build_actor_xrefs(actor)
    @src_type = :actors
    @src_id = actor.id
     
    # Text fields
    scan_db_text(actor.name, :name)
     
    # Class
    save(:classes, actor.class_id, :cls)
   
    # Starting equipment
    save(:weapons, actor.weapon_id, :equips) if actor.weapon_id > 0
    save(:armors, actor.armor1_id, :equips, 1) if actor.armor1_id > 0
    save(:armors, actor.armor2_id, :equips, 2) if actor.armor2_id > 0
    save(:armors, actor.armor3_id, :equips, 3) if actor.armor3_id > 0
    save(:armors, actor.armor4_id, :equips, 4) if actor.armor4_id > 0
  end
   
  def self.build_class_xrefs(cls)
    @src_type = :classes
    @src_id = cls.id
   
    # Text fields
    scan_db_text(cls.name, :name)
   
    # Weapons
    cls.weapon_set.each {|weapon| save(:weapons, weapon, :equips)}
   
    # Armors
    cls.armor_set.each {|armor| save(:armors, armor, :equips)}
   
    # Learnings
    cls.learnings.each_index do |index|
      skill = cls.learnings[index]
      save(:skills, skill.skill_id, :learnings, index) if !skill.nil?
    end
  end
   
  def self.build_skill_xrefs(skill)
    @src_type = :skills
    @src_id = skill.id
   
    # Text fields
    scan_db_text(skill.name, :name)
    scan_db_text(skill.description, :description)
   
    # Animation
    save(:animations, skill.animation1_id, :animations, 1) if skill.animation1_id > 0
    save(:animations, skill.animation2_id, :animations, 2) if skill.animation2_id > 0
   
    # Common event
    save(:common_events, skill.common_event_id, :common_events) if skill.common_event_id > 0
   
    # States
    skill.plus_state_set.each do |state|
      save(:states, state, :plus_state)
    end
    skill.minus_state_set.each do |state|
      save(:states, state, :minus_state)
    end
  end
   
  def self.build_item_xrefs(item)
    @src_type = :items
    @src_id = item.id
   
    # Text fields
    scan_db_text(item.name, :name)
    scan_db_text(item.description, :description)
   
    # Animation
    save(:animations, item.animation1_id, :animations, 1) if item.animation1_id > 0
    save(:animations, item.animation2_id, :animations, 2) if item.animation2_id > 0
   
    # Common event
    save(:common_events, item.common_event_id, :common_events) if item.common_event_id > 0
   
    # States
    item.plus_state_set.each do |state|
      save(:states, state, :plus_state)
    end
    item.minus_state_set.each do |state|
      save(:states, state, :minus_state)
    end
  end
   
  def self.build_weapon_xrefs(weapon)
    @src_type = :weapons
    @src_id = weapon.id
   
    # Text fields
    scan_db_text(weapon.name, :name)
    scan_db_text(weapon.description, :description)
   
    # Animation
    save(:animations, weapon.animation1_id, :animations, 1) if weapon.animation1_id > 0
    save(:animations, weapon.animation2_id, :animations, 2) if weapon.animation2_id > 0
   
    # States
    weapon.plus_state_set.each do |state|
      save(:states, state, :plus_state)
    end
    weapon.minus_state_set.each do |state|
      save(:states, state, :minus_state)
    end
  end
   
  def self.build_armor_xrefs(armor)
    @src_type = :armors
    @src_id = armor.id
   
    # Text fields
    scan_db_text(armor.name, :name)
    scan_db_text(armor.description, :description)
   
    # State
    save(:states, armor.auto_state_id, :states) if armor.auto_state_id > 0
   
    # States
    armor.guard_state_set.each do |state|
      save(:states, state, :guard_state)
    end
  end
   
  def self.build_enemy_xrefs(enemy)
    @src_type = :enemies
    @src_id = enemy.id
   
    # Text fields
    scan_db_text(enemy.name, :name)
   
    # Animation
    save(:animations, enemy.animation1_id, :animations, 1) if enemy.animation1_id > 0
    save(:animations, enemy.animation2_id, :animations, 2) if enemy.animation2_id > 0
   
    # Drop Items
    save(:items, enemy.item_id, :drop_items) if enemy.item_id > 0
    save(:weapons, enemy.weapon_id, :drop_items) if enemy.weapon_id > 0
    save(:armors, enemy.armor_id, :drop_items) if enemy.armor_id > 0
   
    # Actions
    enemy.actions.each_index do |index|
      action = enemy.actions[index]
      save(:skills, action.skill_id, :action_pattern, index) if action.skill_id > 0
      save(:switches, action.condition_switch_id, :action_pattern, index) if action.condition_switch_id > 0
    end
  end
   
  def self.build_troop_xrefs(troop)
    @src_type = :troops
    @src_id = troop.id
   
    # Text fields
    scan_db_text(troop.name, :name)
   
    # Members
    used = []
    troop.members.each_index do |index|
      enemy = troop.members[index].enemy_id
      if !used.include?(enemy)
        save(:enemies, enemy, :member, index)
        used.push(enemy)
      end
    end
   
    # Pages
    troop.pages.each_index do |page|
      @evt_page = page + 1
      @evt_line = nil
     
      # Page condition
      cond = troop.pages[page].condition
      save(:actors, cond.actor_id, :condition) if cond.actor_valid
      save(:switches, cond.switch_id, :condition) if cond.switch_valid
     
      # Event commands
      @list = troop.pages[page].list
      build_event_xrefs
    end
   
    @evt_page = nil
    @evt_line = nil
  end
   
  def self.build_state_xrefs(state)
    @src_type = :states
    @src_id = state.id
   
    # Text fields
    scan_db_text(state.name, :name)
   
    # Animation
    save(:animations, state.animation_id, :animations) if state.animation_id > 0
   
    # States
    state.plus_state_set.each do |state|
      save(:states, state, :plus_state)
    end
    state.minus_state_set.each do |state|
      save(:states, state, :minus_state)
    end
  end
   
  def self.build_common_event_xrefs(evt)
    @src_type = :common_events
    @src_id = evt.id
   
    # Text fields
    scan_db_text(evt.name, :name)
   
    # Conditions
    save(:switches, evt.switch_id, :condition) if evt.trigger > 0
   
    # Event commands
    @list = evt.list
    build_event_xrefs
   
    @evt_line = nil
  end
   
  def self.build_map_xrefs(filename)
    $xref_file.puts(filename)
    map_id = /Data\/Map(\d+)\.rxdata/.match(filename)[1].to_i
    $xref_file.puts(map_id)
    @src_type = :maps
    @src_id = map_id
    map = load_data(filename)
   
    # Text fields
    scan_db_text($data_mapinfos[map_id].name, :name) if $data_mapinfos[map_id]
   
    # Encounters
    map.encounter_list.each do |troop_id|
      save(:troops, troop_id, :encounters)
    end
   
    # Events
    map.events.each do |evt_id, evt|
      next if evt.nil? || evt.pages.nil?
      @evt_id = evt_id
      @evt_name = evt.name
     
      evt.pages.each_index do |page|
        @evt_page = page + 1
        @evt_line = nil
       
        # Conditions
        cond = evt.pages[page].condition
        save(:switches, cond.switch1_id, :condition, 1) if cond.switch1_valid
        save(:switches, cond.switch2_id, :condition, 2) if cond.switch2_valid
        save(:variables, cond.variable_id, :condition, 3) if cond.variable_valid
       
        # Event commands
        @list = evt.pages[page].list
        build_event_xrefs
      end
    end
   
    @evt_page = nil
    @evt_line = nil
  end
 
  def self.build_system_xrefs
    @src_type = :system
    @src_id = 0
   
    # Members
    $data_system.party_members.each do |actor_id|
      save(:actors, actor_id, :starting_members)
    end
  end
 
  def self.build_event_xrefs
    return if @list.nil?
    @list.each_index do |line|
      @evt_line = line + 1
      @cmd_code = @list[line].code
      @params = @list[line].parameters.clone
     
      $xref_file.puts("command " + @cmd_code.to_s + ": " + @params.to_s)
     
      method_name = "build_xrefs_command_#{@cmd_code}"
      send(method_name) if respond_to?(method_name)
    end
  end
 
  # Show Text
  def self.build_xrefs_command_101
    scan_db_text(@params[0])
  end
 
  def self.build_xrefs_command_401
    scan_db_text(@params[0])
  end
 
  # Show Choices
  def self.build_xrefs_command_102
    @params[0].each {|choice| scan_db_text(choice) }
  end
 
  # Input Number
  def self.build_xrefs_command_103
    save(:variables, @params[0])
  end
 
  # Button Input Processing
  def self.build_xrefs_command_105
    save(:variables, @params[0])
  end
 
  # Conditional Branch
  def self.build_xrefs_command_111
    case @params[0]
    when 0 # Switch
      save(:switches, @params[1])
    when 1 # Variable
      save(:variables, @params[1])
      save(:variables, @params[3]) if @params[2] != 0
    when 4 # Actor
      save(:actors, @params[1])
      save(:skills, @params[3]) if @params[2] == 2
      save(:weapons, @params[3]) if @params[2] == 3
      save(:armors, @params[3]) if @params[2] == 4
      save(:states, @params[3]) if @params[2] == 5
    when 5 # Enemy
      save(:states, @params[3]) if @params[2] == 1
    when 8 # Item
      save(:items, @params[1])
    when 9 # Weapons
      save(:weapons, @params[1])
    when 10 # Armors
      save(:armors, @params[1])
    end
  end
 
  # Common Event
  def self.build_xrefs_command_117
    save(:common_events, @params[0])
  end
 
  # Control Switches
  def self.build_xrefs_command_121
    (@params[0]..@params[1]).each do |switch|
      save(:switches, switch)
    end
  end
 
  # Control Variables
  def self.build_xrefs_command_122
    (@params[0]..@params[1]).each do |variable|
      save(:variables, variable)
    end
    save(:variables, @params[4]) if @params[3] == 1
    save(:items, @params[4]) if @params[3] == 3
    save(:actors, @params[4]) if @params[3] == 4
  end
 
  # Change Gold
  def self.build_xrefs_command_125
    save(:variables, @params[2]) if @params[1] != 0
  end
 
  # Change Items
  def self.build_xrefs_command_126
    save(:items, @params[0])
    save(:variables, @params[3]) if @params[2] != 0
  end
 
  # Change Weapons
  def self.build_xrefs_command_127
    save(:weapons, @params[0])
    save(:variables, @params[3]) if @params[2] != 0
  end
 
  # Change Armor
  def self.build_xrefs_command_128
    save(:armors, @params[0])
    save(:variables, @params[3]) if @params[2] != 0
  end
 
  # Change Party Member
  def self.build_xrefs_command_129
    save(:actors, @params[0])
  end
   
  # Transfer Player
  def self.build_xrefs_command_201
    if @params[0] != 0
      save(:variables, @params[1])
      save(:variables, @params[2])
      save(:variables, @params[3])
    end
  end
 
  # Set Event Location
  def self.build_xrefs_command_202
    if @params[1] != 0
      save(:variables, @params[2])
      save(:variables, @params[3])
    end
  end
 
  # Show Animation
  def self.build_xrefs_command_207
    save(:animations, @params[1])
  end
 
  # Set Move Route
  def self.build_xrefs_command_509
    save(:switches, @params[0].parameters[0]) if [27,28].include?(@params[0].code)
  end
 
  # Show Picture
  def self.build_xrefs_command_231
    if @params[3] != 0
      save(:variables, @params[4])
      save(:variables, @params[5])
    end
  end
 
  # Move Picture
  def self.build_xrefs_command_232
    if @params[3] != 0
      save(:variables, @params[4])
      save(:variables, @params[5])
    end
  end
 
  # Battle Processing
  def self.build_xrefs_command_301
    save(:troops, @params[0])
  end
 
  # Shop Processing
  def self.build_xrefs_command_302
    save([:items, :weapons, :armors][@params[0]], @params[1])
  end
 
  def self.build_xrefs_command_605
    save([:items, :weapons, :armors][@params[0]], @params[1])
  end
 
  # Name Input Processing
  def self.build_xrefs_command_303
    save(:actors, @params[0])
  end
 
  # Change HP
  def self.build_xrefs_command_311
    if @params[0] == 0
      $data_actors.compact.each do |actor|
        save(:actors, actor.id)
      end
    else
      save(:actors, @params[0])
    end
    save(:variables, @params[3]) if @params[2] != 0
  end
 
  # Change SP
  def self.build_xrefs_command_312
    if @params[0] == 0
      $data_actors.compact.each do |actor|
        save(:actors, actor.id)
      end
    else
      save(:actors, @params[0])
    end
    save(:variables, @params[3]) if @params[2] != 0
  end
 
  # Change State
  def self.build_xrefs_command_313
    if @params[0] == 0
      $data_actors.compact.each do |actor|
        save(:actors, actor.id)
      end
    else
      save(:actors, @params[0])
    end
    save(:states, @params[3])
  end
 
  # Recover All
  def self.build_xrefs_command_314
    if @params[0] == 0
      $data_actors.compact.each do |actor|
        save(:actors, actor.id)
      end
    else
      save(:actors, @params[0])
    end
  end
 
  # Change EXP
  def self.build_xrefs_command_315
      if @params[0] == 0
      $data_actors.compact.each do |actor|
        save(:actors, actor.id)
      end
    else
      save(:actors, @params[0])
    end
    save(:variables, @params[3]) if @params[2] != 0
  end
 
  # Change Level
  def self.build_xrefs_command_316
    if @params[0] == 0
      $data_actors.compact.each do |actor|
        save(:actors, actor.id)
      end
    else
      save(:actors, @params[0])
    end
  end
 
  # Change Parameters
  def self.build_xrefs_command_317
    if @params[0] == 0
      $data_actors.compact.each do |actor|
        save(:actors, actor.id)
      end
    else
      save(:actors, @params[0])
    end
  end
 
  # Change Skills
  def self.build_xrefs_command_318
    save(:actors, @params[0])
    save(:skills, @params[2])
  end
 
  # Change Equipment
  def self.build_xrefs_command_319
    save(:actors, @params[0])
    save(:weapons, @params[2]) if @params[1] == 0
    save(:armors, @params[2]) if @params[1] != 0
  end
 
  # Change Actor Name
  def self.build_xrefs_command_320
    save(:actors, @params[0])
  end
 
  # Change Actor Class
  def self.build_xrefs_command_321
    save(:actors, @params[0])
    save(:classes, @params[1])
  end
 
  # Change Actor Graphic
  def self.build_xrefs_command_322
    save(:actors, @params[0])
  end
 
  # Change Enemy HP
  def self.build_xrefs_command_331
    save(:variables, @params[3]) if @params[2] != 0
  end
 
  # Change Enemy SP
  def self.build_xrefs_command_332
    save(:variables, @params[3]) if @params[2] != 0
  end
 
  # Change Enemy State
  def self.build_xrefs_command_333
    save(:states, @params[2])
  end
 
  # Enemy Transform
  def self.build_xrefs_command_336
    save(:enemies, @params[1])
  end
 
  # Show Battle Animation
  def self.build_xrefs_command_337
    save(:animations, @params[2])
  end
 
  # Deal Damage
  def self.build_xrefs_command_338
    save(:variables, @params[3]) if @params[2] != 0
  end
 
  # Force Action
  def self.build_xrefs_command_339
    save(:skills, @params[3]) if @params[2] != 0
  end    
end
 
 
class Window_XRef_Selection < Window_Selectable
  def initialize
    super(0, 0, 480, 480)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.active = false
    self.index = 0
    @column_max = 2
    @mode = nil
  end
 
  def set_mode(mode)
    @mode = mode
    refresh
  end
 
  def refresh
    if self.contents != nil
      self.contents.dispose
      self.contents = nil
    end
    @data = Array.new(XRef.data_sources(@mode).size - 1) {|id| id + 1}
    @item_max = @data.size
    self.contents = Bitmap.new(width - 32, row_max * 32)
    for i in 0...@item_max
      draw_item(i)
    end    
    self.index = 0
  end
 
  def item
    @data && index >= 0 ? @data[index] : nil
  end
 
  def draw_item(index)
    item = @data[index]
    return if item.nil?
   
    x = 4 + index % 2 * (208 + 32)
    y = index / 2 * 32
   
    id_text = sprintf('%04d: %s', item, XRef.obj_name(@mode, item))
   
    self.contents.font.color = XRef.refs(@mode, item).empty? ? disabled_color : normal_color
    self.contents.draw_text(x + 4, y + 4, width / 2 - 48, 32, id_text)
  end    
end
 
class Window_XRef_Result < Window_Selectable
  def initialize
    super(0, 64, 640, 416)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.active = false
    self.index = 0
    @column_max = 1
    @mode = nil
    @obj = nil
  end
 
  def set_ref(mode, obj)
    @mode = mode
    @obj = obj
    refresh
  end
 
  def refresh
    if self.contents != nil
      self.contents.dispose
      self.contents = nil
    end
    @data = XRef.refs(@mode, @obj)
    @item_max = @data.size
    self.contents = Bitmap.new(width - 32, row_max * 32)
    for i in 0...@item_max
      draw_item(i)
    end    
    self.index = 0
  end
 
  def draw_item(index)
    item = @data[index]
   
    x = 4 + index % 2 * (288 + 32)
    y = index * 32
   
    rect = Rect.new(x, y, self.width / @column_max - 32, 32)
    self.contents.fill_rect(rect, Color.new(0,0,0,0))
    text = sprintf('%s %d: %s', XRef.data_title(item.src_type), item.src_id, XRef.obj_name(item.src_type, item.src_id))
    self.contents.draw_text(0, y, 288, 32, text)
    if item.evt && item.evt.evt_id
      text =  sprintf('EV%03d: %s', item.evt.evt_id, item.evt.evt_name)
      self.contents.draw_text(300, y, 288, 32, text)
    end
  end
   
  def update_help
    help_text = ''
    item = @data[self.index]
    if !item.nil?
      help_text += sprintf('Page: %s  Line: %s  ',
        item.evt.evt_page.to_s, item.evt.evt_line.to_s) if item.evt
      help_text += XRef.command(item.ref)
    end
    @help_window.set_text(help_text)
  end
end
 
 
#==============================================================================
# ** Scene_XRef
#------------------------------------------------------------------------------
#  This class performs cross reference processing.
#==============================================================================
 
class Scene_XRef
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     menu_index : command cursor's initial position
  #--------------------------------------------------------------------------
  def initialize(menu_index = 0)
    @menu_index = menu_index
    @commands = [:switches, :variables, :common_events, :actors, :classes,
                 :skills, :items, :weapons, :armors, :enemies, :troops,
                 :states, :animations]
  end
  #--------------------------------------------------------------------------
  # * Main Processing
  #--------------------------------------------------------------------------
  def main
    create_command_window
    create_selection_window
    create_help_window
    create_result_window
   
    # Execute transition
    Graphics.transition
    # Main loop
    loop do
      # Update game screen
      Graphics.update
      # Update input information
      Input.update
      # Frame update
      update
      # Abort loop if screen is changed
      if $scene != self
        break
      end
    end
   
    # Prepare for transition
    Graphics.freeze
    # Dispose of windows
    @command_window.dispose
    @selection_window.dispose
    @help_window.dispose
    @result_window.dispose
  end
  #--------------------------------------------------------------------------
  # * Create Command Window
  #--------------------------------------------------------------------------
  def create_command_window
    s1 = "Switches"
    s2 = "Variables"
    s3 = "Common Events"
    s4 = "Actors"
    s5 = "Classes"
    s6 = "Skills"
    s7 = "Items"
    s8 = "Weapons"
    s9 = "Armors"
    s10 = "Enemies"
    s11 = "Troops"
    s12 = "States"
    s13 = "Animations"
               
    @command_window = Window_Command.new(160, [s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13])
    @command_window.disable_item(0) if !XRef.obj_types.include?(:switches)
    @command_window.disable_item(1) if !XRef.obj_types.include?(:variables)
    @command_window.disable_item(2) if !XRef.obj_types.include?(:common_events)
    @command_window.disable_item(3) if !XRef.obj_types.include?(:actors)
    @command_window.disable_item(4) if !XRef.obj_types.include?(:classes)
    @command_window.disable_item(5) if !XRef.obj_types.include?(:skills)
    @command_window.disable_item(6) if !XRef.obj_types.include?(:items)
    @command_window.disable_item(7) if !XRef.obj_types.include?(:weapons)
    @command_window.disable_item(8) if !XRef.obj_types.include?(:armors)
    @command_window.disable_item(9) if !XRef.obj_types.include?(:enemies)
    @command_window.disable_item(10) if !XRef.obj_types.include?(:troops)
    @command_window.disable_item(11) if !XRef.obj_types.include?(:states)
    @command_window.disable_item(12) if !XRef.obj_types.include?(:animations)
   
    @command_window.index = @menu_index
  end
  #--------------------------------------------------------------------------
  # * Create Selection Window
  #--------------------------------------------------------------------------
  def create_selection_window
    @selection_window = Window_XRef_Selection.new
    @selection_window.x = 160
    @selection_window.y = 0
    @selection_window.visible = false
    @selection_window.active = false
  end
  #--------------------------------------------------------------------------
  # * Create Help Window
  #--------------------------------------------------------------------------
  def create_help_window
    @help_window = Window_Help.new
    @help_window.visible = false
  end
  #--------------------------------------------------------------------------
  # * Create Result Window
  #--------------------------------------------------------------------------
  def create_result_window
    @result_window = Window_XRef_Result.new
    @result_window.visible = false
    @result_window.active = false
    @result_window.help_window = @help_window
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    # Update windows
    @command_window.update
    @selection_window.update
    @result_window.update
    @help_window.update
 
    if @command_window.active
      update_command
      return
    end
   
    if @selection_window.active
      update_selection
      return
    end
   
    if @result_window.active
      update_result
      return
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update (when command window is active)
  #--------------------------------------------------------------------------
  def update_command
    # If B button was pressed
    if Keys.trigger?($keyboard["cancel"])
      #Input.trigger?(Input::B)
      # Play cancel SE
      $game_system.se_play($data_system.cancel_se)
      # Switch to map screen
      $scene = Scene_Map.new
      return
    end
    # If C button was pressed
    if Keys.trigger?($keyboard["select"])
      #Input.trigger?(Input::C)
        # Play decision SE
        $game_system.se_play($data_system.decision_se)
        @selection_window.set_mode(@commands[@command_window.index])
       
        @command_window.active = false
        @selection_window.visible = true
        @selection_window.active = true
      return
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update (when selection window is active)
  #--------------------------------------------------------------------------
  def update_selection
    # If B button was pressed
    if Keys.trigger?($keyboard["cancel"])
      #Input.trigger?(Input::B)
      # Play cancel SE
      $game_system.se_play($data_system.cancel_se)
      # Make command window active
      @command_window.active = true
      @selection_window.active = false
      @selection_window.visible = false
      return
    end
    # If C button was pressed
    if Keys.trigger?($keyboard["select"])
      #Input.trigger?(Input::C)
      if XRef.refs(@commands[@command_window.index], @selection_window.item).empty?
        # Play buzzer SE
        $game_system.se_play($data_system.buzzer_se)
      else
        # Play decision SE
        $game_system.se_play($data_system.decision_se)
       
        @result_window.set_ref(@commands[@command_window.index], @selection_window.item)
        @command_window.visible = false
        @selection_window.active = false
        @selection_window.visible = false
        @result_window.active = true
        @result_window.visible = true
        @help_window.visible = true
      end
      return
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update (when result window is active)
  #--------------------------------------------------------------------------
  def update_result
    # If B button was pressed
    if Keys.trigger?($keyboard["cancel"])
      #Input.trigger?(Input::B)
      # Play cancel SE
      $game_system.se_play($data_system.cancel_se)
      # Make selection window active
      @help_window.visible = false
      @result_window.active = false
      @result_window.visible = false
      @selection_window.active = true
      @selection_window.visible = true
      @command_window.visible = true
      return
    end
  end
end
 
 
#==============================================================================
# ** Scene_F9
#------------------------------------------------------------------------------
#  This class allows the user to choose between the debug and XRef menu.
#==============================================================================
 
class Scene_F9
  #--------------------------------------------------------------------------
  # * Main Processing
  #--------------------------------------------------------------------------
  def main
    # Make command window
    s1 = "Debug"
    s2 = "Cross Reference"
    @command_window = Window_Command.new(250, [s1, s2])
    @command_window.back_opacity = 160
    @command_window.x = 320 - @command_window.width / 2
    @command_window.y = 288
   
    # Execute transition
    Graphics.transition
   
    # Main loop
    loop do
      # Update game screen
      Graphics.update
      # Update input information
      Input.update
      # Frame update
      update
      # Abort loop if screen is changed
      if $scene != self
        break
      end
    end
   
    # Prepare for transition
    Graphics.freeze
   
    # Dispose of command window
    @command_window.dispose
  end
 
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    # Update command window
    @command_window.update
 
    # If B button was pressed
    if Keys.trigger?($keyboard["cancel"])
      #Input.trigger?(Input::B)
      # Play cancel SE
      $game_system.se_play($data_system.cancel_se)
      # Switch to map screen
      $scene = Scene_Map.new
      return
    end
   
    # If C button was pressed
    if Keys.trigger?($keyboard["select"])
      #Input.trigger?(Input::C)
      # Branch by command window cursor position
      case @command_window.index
      when 0  # Debug Menu
        $game_system.se_play($data_system.decision_se)
        $scene = Scene_Debug.new
      when 1  # Cross References
        $game_system.se_play($data_system.decision_se)
        XRef.load_xrefs
        $scene = Scene_XRef.new
      end
    end
  end
 
end
 
 
#==============================================================================
# ** Scene_Map
#------------------------------------------------------------------------------
#  This class performs map screen processing.
#==============================================================================
 
class Scene_Map
  #--------------------------------------------------------------------------
  # * Debug Call
  #--------------------------------------------------------------------------
  def call_debug
    # Clear debug call flag
    $game_temp.debug_calling = false
    # Play decision SE
    $game_system.se_play($data_system.decision_se)
    # Straighten player position
    $game_player.straighten
    # Switch to debug screen
    $scene = Scene_F9.new
  end
end
#=end