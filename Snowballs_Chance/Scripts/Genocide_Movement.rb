# This script is taken from the German RPGXP project "Genocide" and adjusted
# for standalone usage. Permission is granted by the author to freely use and
# edit it as long as the game "Genocide" and the code's original author remain
# credited in the code. Other means of crediting are voluntary, but appreciated.

module Genocide_Movement
	# Configuration:
	# Default 1/4 of a Tile an Event is moving
	# Standard: 4 (32px), Minimum: 1(8px), Maximum: 4(32px)
	EVENT_DISTANCE = 4
	# Default 1/4 of a Tile the Player is moving
	# Standard: 4 (32px), Minimum: 1(8px), Maximum: 4(32px)
	PLAYER_DISTANCE = 2
	# Turn Diagonalmove on or off
	# Standard: true, Deactivate: false
	PLAYER_8_DIR = true
	# Key for Strafe:
	# Standard: Input::SHIFT, Deactivate: nil
	STRAFE_KEY = Input::SHIFT
	# Cost for Diagonalmove
	# Standard: Math.sqrt(2), Deactivate: nil
	DIAGONAL_COST = Math.sqrt(2)

	class ::Numeric
		# Map Position Coordinates calculate from Flowpoint Coordinates
		def to_field
			if (i = to_i) == self
				i
			else
				(self-0.125).round
			end
		end
	end

	class ::Game_Character
		#--------------------------------------------------------------------------
		# * Calculate new position
		#     x : x-coordinate
		#     y : y-coordinate
		#     d : direction (0,1,2,3,4,6,7,8,9)
		#         * 0 = no change
		#     s : steps (1..4)
		#--------------------------------------------------------------------------
		def get_new_coordinates(x, y, d, s = EVENT_DISTANCE)
			# Get move distance
			s *= 0.25
			# Get new coordinates
			if d != 0
				dx = (d % 3 == 0 ? 1 : d % 3 == 1 ? -1 : 0)
				dy = (d <= 3 ? 1 : d >= 7 ? -1 : 0)
				new_x, new_y = x + dx * s, y + dy * s
			else
				dx = dy = 0
				new_x, new_y = x, y
			end
			[new_x, new_y, dx, dy]
		end
		#--------------------------------------------------------------------------
		# * Determine if Passable
		#     x : x-coordinate
		#     y : y-coordinate
		#     d : direction (0,1,2,3,4,6,7,8,9)
		#         * 0 = Determines if all directions are impassable (for jumping)
		#     s : steps (1..4)
		#     n : new coordinates as calculated by get_new_coordinates
		#         if not specified, they are calculated here
		#--------------------------------------------------------------------------
		def passable?(x, y, d, s = EVENT_DISTANCE, n = get_new_coordinates(x, y, d, s))
			# Get new coordinates
			new_x, new_y, dx, dy = *n
			# If coordinates are outside of map: impassable
			return false unless $game_map.valid?(new_x, new_y)
			# If through is ON: passable
			return true if @through
			# Get move distance
			s *= 0.25
			# Calculate Standfield
			fx, fy = x.to_field, y.to_field
			# Check, if moving to new field
			cx = ((x - fx).abs < s and 0 < dx*(new_x - x))
			cy = ((y - fy).abs < s and 0 < dy*(new_y - y))
			if cx and cy
				return false unless $game_map.passable?(fx, fy, d) and $game_map.passable?(fx + dx, fy + dy, 10 - d)
			elsif cx
				# Normal Check
				return false unless $game_map.passable?(fx, fy, 5 + dx) and $game_map.passable?(fx + dx, fy, 5 - dx)
				# If Player is between 2 Tiles...
				if y != fy
					cy = fy + (y <=> fy)
					# ... Check neighbor Tile...
					return false unless $game_map.passable?(fx, cy, 5 + dx) and $game_map.passable?(fx + dx, cy, 5 - dx)
					# ... Make sure, fy ist the Tile above, cy the Tile below...
					fy, cy = cy, fy if cy < fy
					y = (y - fy) % 1
					# ... check above Tile to the south...
					return false if y <= 0.5 and not ($game_map.passable?(fx + dx, cy, 2) and $game_map.passable?(fx + dx, fy, 8))
					# ... and check below Tile to the north
					return false if y >= 0.5 and not ($game_map.passable?(fx + dx, fy, 8) and $game_map.passable?(fx + dx, cy, 2))
				end
			elsif cy
				# Normal Check
				return false unless $game_map.passable?(fx, fy, 5 - 3 * dy) and $game_map.passable?(fx, fy + dy, 5 + 3 * dy)
				# If Player is between 2 Tiles...
				if x != fx
					cx = fx + (x <=> fx)
					# ... Check neighbor Tile...
					return false unless $game_map.passable?(cx, fy, 5 - 3 * dy) and $game_map.passable?(cx, fy + dy, 5 + 3 * dy)
					# ... Make sure, fx ist the Tile left, cx the Tile right...
					fx, cx = cx, fx if cx < fx
					x = (x - fx) % 1
					# ... check right Tile to the left...
					return false if x <= 0.5 and not ($game_map.passable?(cx, fy + dy, 4) and $game_map.passable?(fx, fy + dy, 6))
					# ... and check left Tile to the right...
					return false if x >= 0.5 and not ($game_map.passable?(fy, fy + dy, 6) and $game_map.passable?(cx, fy + dy, 4))
				end
			end
			# Loop all events
			for event in $game_map.events.values
				next if event == self or event.through
				# If through is OFF and (self is player => partner graphic as character)
				# and event coordinates are consistent with move destination
				if #not event.through and event.character_name != "" and
					(self != $game_player or event.character_name != "") and
					(event.x - new_x).abs < 1 and (event.y - new_y).abs < 1
					# impassable
					return false
				end
			end
			# If self is not player, player through is OFF coordinates are consistent
			# with move destination and your own graphic is the character
			if self != $game_player and not $game_player.through and
				@character_name != "" and ($game_player.x - new_x).abs < 1 and
				($game_player.y - new_y).abs < 1
				# impassable
				return false
			end
			# passable
			return true
		end
		#--------------------------------------------------------------------------
		# * Move
		#     dir          : direction (0,1,2,3,4,6,7,8,9)
		#     steps        : number of steps to move (4 = 1 field)
		#     turn_enabled : a flag permits direction change on that spot
		#--------------------------------------------------------------------------
		def move(dir, steps = EVENT_DISTANCE, turn_enabled = true)
			return if dir == 0
			turned = false
			# Turn to specified direction
			if turn_enabled
				turn(dir)
				turned = true
			end
			# Calculate new coordinates
			new_coords = get_new_coordinates(@x, @y, dir, steps)
			# If passable and route free
			if passable?(@x, @y, dir, steps, new_coords)
				# Turn to specified direction
				turn(dir) unless turned
				# Update coordinates
				@x, @y = new_coords
				# Increase steps
				increase_steps
			# Slide if moving diagonally
			elsif dir % 2 == 1 and
					((m = dir % 6) == 1 and passable?(@x, @y, 4, steps, n = get_new_coordinates(@x, @y, 4, steps)) or
						(m == 3 and passable?(@x, @y, 6, steps, n = get_new_coordinates(@x, @y, 6, steps))) or
						(dir < 5 and passable?(@x, @y, 2, steps, n = get_new_coordinates(@x, @y, 2, steps))) or
						(dir > 5 and passable?(@x, @y, 8, steps, n = get_new_coordinates(@x, @y, 8, steps))))
				# Update coordinates
				@x, @y = n#ew_coords
				# Increase steps
				increase_steps
			# If impassable
			else
				# Determine if touch event is triggered
				check_event_trigger_touch(new_coords[0], new_coords[1])
			end
		end
		#--------------------------------------------------------------------------
		# * Move Down
		#     turn_enabled : a flag permits direction change on that spot
		#     steps        : number of steps to move (4 = 1 field)
		#--------------------------------------------------------------------------
		def move_down(turn_enabled = true, steps = EVENT_DISTANCE)
			move(2, steps, turn_enabled)
		end
		#--------------------------------------------------------------------------
		# * Move Left
		#     turn_enabled : a flag permits direction change on that spot
		#     steps        : number of steps to move (4 = 1 field)
		#--------------------------------------------------------------------------
		def move_left(turn_enabled = true, steps = EVENT_DISTANCE)
			move(4, steps, turn_enabled)
		end
		#--------------------------------------------------------------------------
		# * Move Right
		#     turn_enabled : a flag permits direction change on that spot
		#     steps        : number of steps to move (4 = 1 field)
		#--------------------------------------------------------------------------
		def move_right(turn_enabled = true, steps = EVENT_DISTANCE)
			move(6, steps, turn_enabled)
		end
		#--------------------------------------------------------------------------
		# * Move up
		#     turn_enabled : a flag permits direction change on that spot
		#     steps        : number of steps to move (4 = 1 field)
		#--------------------------------------------------------------------------
		def move_up(turn_enabled = true, steps = EVENT_DISTANCE)
			move(8, steps, turn_enabled)
		end
		#--------------------------------------------------------------------------
		# * Move Lower Left
		#     steps        : number of steps to move (4 = 1 field)
		#--------------------------------------------------------------------------
		def move_lower_left(steps = EVENT_DISTANCE)
			move(1, steps)
		end
		#--------------------------------------------------------------------------
		# * Move Lower Right
		#     steps        : number of steps to move (4 = 1 field)
		#--------------------------------------------------------------------------
		def move_lower_right(steps = EVENT_DISTANCE)
			move(3, steps)
		end
		#--------------------------------------------------------------------------
		# * Move Upper Left
		#     steps        : number of steps to move (4 = 1 field)
		#--------------------------------------------------------------------------
		def move_upper_left(steps = EVENT_DISTANCE)
			move(7, steps)
		end
		#--------------------------------------------------------------------------
		# * Move Upper Right
		#     steps        : number of steps to move (4 = 1 field)
		#--------------------------------------------------------------------------
		def move_upper_right(steps = EVENT_DISTANCE)
			move(9, steps)
		end
		#--------------------------------------------------------------------------
		# * Turn
		#     d     : direction (1,2,3,4,6,7,8,9)
		#--------------------------------------------------------------------------
		def turn(d)
			# If no direction fix
			unless @direction_fix
				if d % 2 == 1
					# If diagonal direction specified, replace it with good straight
					# direction if the character is facing an opposite direction
					if ((m = d % 6) == 1 and @direction == 6) or
							(m == 3 and @direction == 4) or
							(d < 5 and @direction == 8) or
							(d > 5 and @direction == 2)
						@direction = 10 - @direction
					end
				else
					@direction = d
				end
				@stop_count = 0
			end
		end
		#--------------------------------------------------------------------------
		# * Update frame (move)
		#--------------------------------------------------------------------------
		def update_move
			# Convert map coordinates from map move speed into move distance
			distance = 2 ** @move_speed
			# Apply cost for diagonal movement
			if DIAGONAL_COST and @x * 128 != @real_x and @y * 128 != @real_y
				distance = (distance / DIAGONAL_COST).round
			end
			# If logical coordinates are further down than real coordinates
			if @y * 128 > @real_y
				# Move down
				@real_y = [@real_y + distance, @y * 128].min
			end
			# If logical coordinates are more to the left than real coordinates
			if @x * 128 < @real_x
				# Move left
				@real_x = [@real_x - distance, @x * 128].max
			end
			# If logical coordinates are more to the right than real coordinates
			if @x * 128 > @real_x
				# Move right
				@real_x = [@real_x + distance, @x * 128].min
			end
			# If logical coordinates are further up than real coordinates
			if @y * 128 < @real_y
				# Move up
				@real_y = [@real_y - distance, @y * 128].max
			end
			# If move animation is ON
			if @walk_anime
				# Increase animation count by 1.5
				@anime_count += 1.5
			# If move animation is OFF, and stop animation is ON
			elsif @step_anime
				# Increase animation count by 1
				@anime_count += 1
			end
		end
	end

	class ::Game_Event
		#--------------------------------------------------------------------------
		# * Touch Event Starting Determinant
		#--------------------------------------------------------------------------
		def check_event_trigger_touch(x, y)
			# If event is running
			if $game_system.map_interpreter.running?
				return
			end
			# If starting determinant other than jumping is front event and
			# trigger is [touch from event] and consistent with player coordinates
			if @trigger == 2 and not over_trigger? and not jumping? and
				($game_player.x - @x).abs <= 0.5 and ($game_player.y - @y).abs <= 0.5
				start
			end
		end
		#--------------------------------------------------------------------------
		# * Automatic Event Starting Determinant
		#--------------------------------------------------------------------------
		def check_event_trigger_auto
			# If starting determinant other than jumping is same position event and
			# trigger is [touch from event] and consistent with player coordinates
			if @trigger == 2 and over_trigger? and not jumping? and
				($game_player.x - @x).abs <= 0.5 and ($game_player.y - @y).abs <= 0.5
				start
			# If trigger is [auto run]
			elsif @trigger == 3
				start
			end
		end
	end

	# Shots/Hits and 8Dir- and Pixelmovement
	class ::Game_Player
		def move(dir, steps = PLAYER_DISTANCE, turn_enabled = true)
			super
		end
		#--------------------------------------------------------------------------
		# * Frame Update
		#--------------------------------------------------------------------------
		def update
			# Remember whether or not moving in local variables
			last_moving = moving?
			# Fix Direction
			if STRAFE_KEY
				if  Keys.press?($keyboard["strafe"]) #Input.press?(STRAFE_KEY)
					if @pre_fix == nil
						@pre_fix = @direction_fix
						@direction_fix = true
					end
				elsif @pre_fix != nil
					@direction_fix = @pre_fix
					@pre_fix = nil
				end
			end
			# If moving, event running, move route forcing, and message window
			# display are all not occurring
			if not (moving? or $game_system.map_interpreter.running? or
						@move_route_forcing or $game_temp.message_window_showing)
				# Move player in the direction the directional button is being pressed
				move(PLAYER_8_DIR ? Input.dir8 : Input.dir4)
			end
			# Remember coordinates in local variables
			last_real_x = @real_x
			last_real_y = @real_y
			super
			# If character moves down and is positioned lower than the center
			# of the screen
			if @real_y > last_real_y and @real_y - $game_map.display_y > CENTER_Y
				# Scroll map down
				$game_map.scroll_down(@real_y - last_real_y)
			end
			# If character moves left and is positioned more let on-screen than
			# center
			if @real_x < last_real_x and @real_x - $game_map.display_x < CENTER_X
				# Scroll map left
				$game_map.scroll_left(last_real_x - @real_x)
			end
			# If character moves right and is positioned more right on-screen than
			# center
			if @real_x > last_real_x and @real_x - $game_map.display_x > CENTER_X
				# Scroll map right
				$game_map.scroll_right(@real_x - last_real_x)
			end
			# If character moves up and is positioned higher than the center
			# of the screen
			if @real_y < last_real_y and @real_y - $game_map.display_y < CENTER_Y
				# Scroll map up
				$game_map.scroll_up(last_real_y - @real_y)
			end
			# If not moving
			unless moving?
				# If player was moving last time
				if last_moving
					# Event determinant is via touch of same position event
					result = check_event_trigger_here([1,2])
					# If event which started does not exist
					if result == false
						# Disregard if debug mode is ON and ctrl key was pressed
						unless $DEBUG and Input.press?(Input::CTRL)
							# Encounter countdown
							if @encounter_count > 0
								@encounter_count -= 1
							end
						end
					end
				end
				# If C button was pressed
				if Input.trigger?(Input::C)
					# Same position and front event determinant
					check_event_trigger_here([0])
					check_event_trigger_there([0,1,2])
				end
			end
		end
		#--------------------------------------------------------------------------
		# * Passable Determinants
		#     x : x-coordinate
		#     y : y-coordinate
		#     d : direction (0,2,4,6,8)
		#         * 0 = Determines if all directions are impassable (for jumping)
		#     s : steps (1..4)
		#--------------------------------------------------------------------------
		def passable?(x, y, d, s = 4, n = get_new_coordinates(x, y, d, s))
			# If coordinates are outside of map: impassable
			return false unless $game_map.valid?(n[0], n[1])
			# If debug mode is ON and ctrl key was pressed: passable
			return true if $DEBUG and Input.press?(Input::CTRL)
			super
		end
		#--------------------------------------------------------------------------
		# * Same Position Starting Determinant
		#--------------------------------------------------------------------------
		def check_event_trigger_here(triggers)
			# If no event is running
			unless $game_system.map_interpreter.running?
				# All event loops
				for event in $game_map.events.values
					# If triggers are consistent, starting determinant is same position event
					# (other than jumping) and event coordinates are consistent
					if event.over_trigger? and triggers.include?(event.trigger) and
							(not event.jumping?) and (event.x - @x).abs <= 0.5 and (event.y - @y).abs <= 0.5
						event.start
						return true
					end
				end
			end
			return false
		end
		#--------------------------------------------------------------------------
		# * Front Envent Starting Determinant
		#--------------------------------------------------------------------------
		def check_event_trigger_there(triggers)
			# If no event is running
			unless $game_system.map_interpreter.running?
				# Calculate front event coordinates
				new_x = @x + (@direction == 6 ? 1 : @direction == 4 ? -1 : 0)
				new_y = @y + (@direction == 2 ? 1 : @direction == 8 ? -1 : 0)
				# All event loops
				for event in $game_map.events.values
					# If triggers are consistent, starting determinant is front event
					# (other than jumping) and event coordinates are consistent
					if not event.over_trigger? and triggers.include?(event.trigger) and
							not event.jumping? and (event.x - new_x).abs <= 0.5 and (event.y - new_y).abs <= 0.5
						event.start
						return true
					end
				end
				# If front tile is a counter
				if $game_map.counter?(new_x, new_y)
					# Calculate 1 tile inside coordinates
					new_x += (@direction == 6 ? 1 : @direction == 4 ? -1 : 0)
					new_y += (@direction == 2 ? 1 : @direction == 8 ? -1 : 0)
					# All event loops
					for event in $game_map.events.values
						# If triggers are consistent, starting determinant is front event
						# (other than jumping) and event coordinates are consistent
						if not event.over_trigger? and triggers.include?(event.trigger) and
								not event.jumping? and (event.x - new_x).abs <= 0.5 and (event.y - new_y).abs <= 0.5
							event.start
							return true
						end
					end
				end
			end
			return false
		end
		#--------------------------------------------------------------------------
		# * Touch Event Starting Determinant
		#--------------------------------------------------------------------------
		def check_event_trigger_touch(x, y)
			# If no event is running
			unless $game_system.map_interpreter.running?
				# All event loops
				for event in $game_map.events.values
					# If triggers are consistent, starting determinant is front event
					# (other than jumping) and event coordinates are consistent
					if not event.over_trigger? and not event.jumping? and
							[1,2].include?(event.trigger) and (event.x - x).abs <= 0.5 and (event.y - y).abs <= 0.5
						event.start
						return true
					end
				end
			end
			return false
		end
	end

	class ::Game_Map
		alias :old_passable? :passable?
		#--------------------------------------------------------------------------
		# * Determine if Passable
		#     x          : x-coordinate
		#     y          : y-coordinate
		#     d          : direction (0,...,10)
		#                  *  0,10 = determine if all directions are impassable
		#     self_event : Self (If event is determined passable)
		#--------------------------------------------------------------------------
		def passable?(x, y, d, self_event = nil)
			# Handle diagonal passability
			if d % 2 == 1
				# Calculate temporary movement direction indicators
				dx, dy = d % 3 == 1 ? -1 : 1, 6 <=> d
				# Get new position
				new_x, new_y = x + dx, y + dy
				# Get movement directions
				dx, dy = 5 + dx, 5 + 3 * dy
				# Calculate passability
				passable?(x, y, dx, self_event) and passable?(x, new_y, dx, self_event) and
				passable?(x, y, dy, self_event) and passable?(new_x, y, dy, self_event)
			else
				old_passable?(x, y, d, self_event)
			end
		end
	end
end