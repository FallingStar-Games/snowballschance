=begin
#============================================================================
# Multi Layer Fog
# v2.0 by Shaz
#----------------------------------------------------------------------------
# This script lets you add one or more layers of fog to a map.
# You can add vertical and/or horizontal scrolling to each fog layer.
# You can have fog appear on top of the map or behind the map (above the
# parallax layer).
# You can adjust the fog's opacity and tone over time.
#----------------------------------------------------------------------------
# History
# v2.0 - attempt to fix the "stick with player" issue some people were having
#----------------------------------------------------------------------------
# To Install:
# Copy and paste into a new script slot in Materials. This script aliases
# existing methods, so can go below all other custom scripts.
#----------------------------------------------------------------------------
# To Use:
# Create a Fogs folder inside your game's Graphics folder, and paste your
# fog png files there.
#
# To add fog to a map, use the following in a Call Script event command:
# show_fog(number, "filename", hue, opacity, blend_type, zoom, 
# speed-x, speed-y, z)
# - only number and filename are mandatory
# - fog is added like pictures - the number is simply an id (an array index),
# and if you don't specify the z value, fog with a higher number/id is drawn
# over fog with a lower number/id
# - z position defaults to above the player. If you want to show fog above the 
# parallax layer but behind the map, use a negative value for z. The 
# parallax is drawn at -100
#
# To change fog tone, use the following in a Call Script event command:
# tint_fog(number, red, green, blue, gray, duration)
#
# To change the fog opacity, use the following in a Call Script event command:
# fade_fog(number, opacity, duration)
#
# To remove fog, use the following in a Call Script event command:
# erase_fog(number)
#
# By default fog will be removed when you change maps, and battle screens 
# will have the same fog as the map. Change the CUSTOMIZATION options below
# if you do not want this.
#----------------------------------------------------------------------------
# Terms:
# Use in free or commercial games
# Credit Shaz
#============================================================================
#============================================================================
# CUSTOMIZATION
#
# Set this to true or false to show (or not show) fog in the battle screen
BATTLE_FOGS = true

# Set this to true or false to clear (or not clear) fogs on transfer to new map
CLEAR_ON_TRANSFER = true

# DO NOT CHANGE ANYTHING BELOW THIS LINE
#============================================================================
module Cache
	#--------------------------------------------------------------------------
	# * Get Fog
	#--------------------------------------------------------------------------
	def self.fog(filename, hue)
		load_bitmap("Graphics/Fogs/", filename, hue)
	end
end

class Game_Screen
	#--------------------------------------------------------------------------
	# * Public Instance Variables
	#--------------------------------------------------------------------------
	attr_reader :fogs
	#--------------------------------------------------------------------------
	# * Object Initialization
	#--------------------------------------------------------------------------
	alias shaz_multi_fog_game_screen_initialize initialize
	def initialize
		@fogs = Game_Fogs.new
		shaz_multi_fog_game_screen_initialize
	end
	#--------------------------------------------------------------------------
	# * Clear
	#--------------------------------------------------------------------------
	#alias shaz_multi_fog_game_screen_clear fogclear
	def fogclear
		shaz_multi_fog_game_screen_clear
		clear_fogs
	end
	#--------------------------------------------------------------------------
	# * Clear Fogs
	#--------------------------------------------------------------------------
	def clear_fogs 
		@fogs.each {|fog| fog.erase} 
	end
	#--------------------------------------------------------------------------
	# * Frame Update
	#-------------------------------------------------------------------------- 
	alias shaz_multi_fog_game_screen_update update
	def update 
		shaz_multi_fog_game_screen_update 
		update_fogs 
	end
	#--------------------------------------------------------------------------
	# * Object Initialization
	#--------------------------------------------------------------------------
	def update_fogs 
		@fogs.each {|fog| fog.update} 
	end
end 

class Game_Fog
	#--------------------------------------------------------------------------
	# * Public Instance Variables
	#-------------------------------------------------------------------------- 
	attr_reader :number 
	attr_reader :name 
	attr_reader :hue 
	attr_reader :opacity 
	attr_reader :blend_type 
	attr_reader :zoom 
	attr_reader :sx 
	attr_reader :sy 
	attr_reader :ox 
	attr_reader :oy 
	attr_reader :tone 
	attr_reader :z
	#--------------------------------------------------------------------------
	# * Object Initialization
	#--------------------------------------------------------------------------
	def initialize(number) 
		@number = number 
		init_basic 
		init_movement 
		init_tone 
		init_opacity 
	end
	#--------------------------------------------------------------------------
	# * Initialize Basic Variable
	#--------------------------------------------------------------------------
	def init_basic 
		@name = "" 
		@hue = 90 
		@blend_type = 0 
		@zoom = 200 
		@sx = @sy = 0 
	end
	#--------------------------------------------------------------------------
	# * Initialize Movement Variable
	#--------------------------------------------------------------------------
	def init_movement 
		@ox = @oy = 0 
	end
	#--------------------------------------------------------------------------
	# * Initialize Tone
	#--------------------------------------------------------------------------
	def init_tone 
		@tone = Tone.new 
		@tone_target = Tone.new 
		@tone_duration = 0 
	end
	#--------------------------------------------------------------------------
	# * Initialize Opacity
	#--------------------------------------------------------------------------
	def init_opacity 
		@opacity = 64.0 
		@opacity_target = 64.0 
		@opacity_duration = 0 
	end
	#--------------------------------------------------------------------------
	# * Show Fog
	#--------------------------------------------------------------------------
	def show(name, hue, opacity, blend_type, zoom, sx, sy, z) 
		@name = name 
		@hue = hue 
		@opacity = opacity 
		@blend_type = blend_type 
		@zoom = zoom 
		@sx = @sx2 = sx 
		@sy = @sy2 = sy 
		@z = z.nil? ? 300 + @number : z 
		init_movement 
	end
	#--------------------------------------------------------------------------
	# * Start Changing Tone
	#--------------------------------------------------------------------------
	def start_tone_change(tone, duration) 
		@tone_target = tone.clone 
		@tone_duration = duration 
		@tone = @tone_target.clone if @tone_duration == 0 
	end
	#--------------------------------------------------------------------------
	# * Start Opacity Change
	#--------------------------------------------------------------------------
	def start_opacity_change(opacity, duration) 
		@opacity_target = opacity * 1.0 
		@opacity_duration = duration 
		@opacity = @opacity_target if @opacity_duration == 0 
	end
	#--------------------------------------------------------------------------
	# * Erase Fog
	#--------------------------------------------------------------------------
	def erase 
		@name = "" 
	end
	#--------------------------------------------------------------------------
	# * Frame Update
	#--------------------------------------------------------------------------
	def update 
		update_move 
		update_tone_change 
		update_opacity_change 
	end
	#--------------------------------------------------------------------------
	# * Update Fog Move
	#--------------------------------------------------------------------------
	def update_move 
		@sx2 -= @sx / 8.0 
		@sy2 -= @sy / 8.0 
		@ox = $game_map.display_x * 32 + @sx2 
		@oy = $game_map.display_y * 32 + @sy2 
	end
	#--------------------------------------------------------------------------
	# * Update Fog Tone Change
	#--------------------------------------------------------------------------
	def update_tone_change 
		return if @tone_duration == 0 
		d = @tone_duration 
		target = @tone_target 
		@tone.red = (@tone.red * (d - 1) + target.red) / d 
		@tone.green = (@tone.green * (d - 1) + target.green) / d 
		@tone.blue = (@tone.blue * (d - 1) + target.blue) / d 
		@tone.gray = (@tone.gray * (d - 1) + target.gray) / d 
		@tone_duration -= 1 
	end
	#--------------------------------------------------------------------------
	# * Update Fog Opacity Change
	#--------------------------------------------------------------------------
	def update_opacity_change 
		return if @opacity_duration == 0 
		d = @opacity_duration 
		@opacity = (@opacity * (d - 1) + @opacity_target) / d 
		@opacity_duration -= 1 
	end
end

class Game_Fogs
	#--------------------------------------------------------------------------
	# * Object Initialization
	#--------------------------------------------------------------------------
	def initialize 
		@data = [] 
	end
	#--------------------------------------------------------------------------
	# * Get Picture
	#--------------------------------------------------------------------------
	def [](number) 
		@data[number] ||= Game_Fog.new(number) 
	end
	#--------------------------------------------------------------------------
	# * Iterator
	#--------------------------------------------------------------------------
	def each 
		@data.compact.each {|fog| yield fog } if block_given? 
	end
end

if CLEAR_ON_TRANSFER 
	class Game_Player < Game_Character
		#--------------------------------------------------------------------------
		# * Execute Player Transfer
		#-------------------------------------------------------------------------- 
		#alias shaz_multi_fog_game_player_perform_transfer perform_transfer
		def perform_transfer 
			if transfer? && @new_map_id != $game_map.map_id 
				$game_map.screen.fogs.each { |fog| fog.erase } 
			end 
			shaz_multi_fog_game_player_perform_transfer 
		end 
	end
end

class Game_Interpreter
	#--------------------------------------------------------------------------
	# * Show Fog
	#--------------------------------------------------------------------------
	def show_fog(number, name, hue = 90, opacity = 64.0, blend_type = 0, zoom = 200, sx = 0, sy = 0, z = nil) 
		screen.fogs[number].show(name, hue, opacity, blend_type, zoom, sx, sy, z) 
	end
	#--------------------------------------------------------------------------
	# * Tint Fog
	#--------------------------------------------------------------------------
	def tint_fog(number, red, green, blue, gray, duration) 
		screen.fogs[number].start_tone_change(Tone.new(red, green, blue, gray), duration) 
	end
	#--------------------------------------------------------------------------
	# * Change Fog Opacity
	#--------------------------------------------------------------------------
	def fade_fog(number, opacity, duration) 
		screen.fogs[number].start_opacity_change(opacity, duration) 
	end
	#--------------------------------------------------------------------------
	# * Erase Fog
	#--------------------------------------------------------------------------
	def erase_fog(number) 
		screen.fogs[number].erase 
	end
end

class Plane_Fog < Plane
	#--------------------------------------------------------------------------
	# * Object Initialization
	#--------------------------------------------------------------------------
	def initialize(viewport, fog) 
		super(viewport) 
		@fog = fog 
		self.z = @fog.z 
		self.zoom_x = @fog.zoom / 100 
		self.zoom_y = @fog.zoom / 100 
		self.blend_type = @fog.blend_type 
		update 
	end
	#--------------------------------------------------------------------------
	# * Free
	#--------------------------------------------------------------------------
	def dispose 
		bitmap.dispose if bitmap 
		super 
	end
	#--------------------------------------------------------------------------
	# * Frame Update
	#--------------------------------------------------------------------------
	def update 
		update_bitmap 
		update_move 
		update_tone 
		update_opacity 
	end
	#--------------------------------------------------------------------------
	# * Update Bitmap
	#--------------------------------------------------------------------------
	def update_bitmap 
		if @fog.name.empty? 
			self.bitmap = nil 
		else 
			self.bitmap = Cache.fog(@fog.name, @fog.hue) 
		end 
	end
	#--------------------------------------------------------------------------
	# * Update Move
	#--------------------------------------------------------------------------
	def update_move 
		self.ox = @fog.ox 
		self.oy = @fog.oy 
	end
	#--------------------------------------------------------------------------
	# * Update Tone
	#--------------------------------------------------------------------------
	def update_tone 
		self.tone = @fog.tone 
	end
	#--------------------------------------------------------------------------
	# * Update Opacity
	#--------------------------------------------------------------------------
	def update_opacity 
		self.opacity = @fog.opacity 
	end
end 

class Spriteset_Map
	#--------------------------------------------------------------------------
	# * Object Initialization
	#-------------------------------------------------------------------------- 
	alias shaz_multi_fog_spriteset_map_initialize initialize
	def initialize 
		shaz_multi_fog_spriteset_map_initialize 
		create_fogs 
		update 
	end
	#--------------------------------------------------------------------------
	# * Create Fog Plane
	#--------------------------------------------------------------------------
	def create_fogs 
		@fog_planes = [] 
	end
	#--------------------------------------------------------------------------
	# * Free
	#-------------------------------------------------------------------------- 
	alias shaz_multi_fog_spriteset_map_dispose dispose
	def dispose 
		dispose_fogs 
		shaz_multi_fog_spriteset_map_dispose 
	end
	#--------------------------------------------------------------------------
	# * Free Fog Plane
	#--------------------------------------------------------------------------
	def dispose_fogs 
		@fog_planes.compact.each {|fog| fog.dispose } 
	end
	#--------------------------------------------------------------------------
	# * Frame Update
	#-------------------------------------------------------------------------- 
	alias shaz_multi_fog_spriteset_map_update update
	def update 
		update_fogs 
		shaz_multi_fog_spriteset_map_update 
	end
	#--------------------------------------------------------------------------
	# * Update Fogs
	#--------------------------------------------------------------------------
	def update_fogs 
		return if !@fog_planes 
		$game_map.screen.fogs.each do |fog| 
			@fog_planes[fog.number] ||= Plane_Fog.new(@viewport1, fog) 
			@fog_planes[fog.number].update 
		end 
	end
end

if BATTLE_FOGS 
	class Spriteset_Battle
		#--------------------------------------------------------------------------
		# * Object Initialization
		#-------------------------------------------------------------------------- 
		alias shaz_multi_fog_spriteset_battle_initialize initialize
		def initialize 
			shaz_multi_fog_spriteset_battle_initialize 
			create_fogs 
			update 
		end
		#--------------------------------------------------------------------------
		# * Create Fog Plane
		#--------------------------------------------------------------------------
		def create_fogs 
			@fog_planes = [] 
		end
		#--------------------------------------------------------------------------
		# * Free
		#-------------------------------------------------------------------------- 
		alias shaz_multi_fog_spriteset_map_dispose dispose
		def dispose 
			dispose_fogs 
			shaz_multi_fog_spriteset_map_dispose 
		end
		#--------------------------------------------------------------------------
		# * Free Fog Plane
		#--------------------------------------------------------------------------
		def dispose_fogs 
			@fog_planes.compact.each {|fog| fog.dispose } 
		end
		#--------------------------------------------------------------------------
		# * Frame Update
		#-------------------------------------------------------------------------- 
		alias shaz_multi_fog_spriteset_map_update update
		def update 
			update_fogs 
			shaz_multi_fog_spriteset_map_update 
		end
		#--------------------------------------------------------------------------
		# * Update Fogs
		#--------------------------------------------------------------------------
		def update_fogs 
			return if !@fog_planes 
			$game_map.screen.update_fogs 
			$game_map.screen.fogs.each do |fog| 
				@fog_planes[fog.number] ||= Plane_Fog.new(@viewport1, fog) 
				@fog_planes[fog.number].update 
			end 
		end 
	end
end # BATTLE_FOGS
=end