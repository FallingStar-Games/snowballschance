#==============================================================================
#
# Keyboard Script v3									  created by: cybersam
#
# its a small update...
# this have a script in it that allows you to insert a text with the keyboard
# inside the game... scroll down the script lit and you'll see it ^-^
# there is a new event on the map that shows you how it works...
# you can use the variables and command in the event in a script as well 
# since it works with "call script"
# now then... have fun with it ^-^
#
#==============================================================================
#
# hi guys.... it me again... ^-^
#
# now... this script is for more keys to press...
# anyone you like...
#
# mostly all keys are added...
#
# this version is now as module and easier to add to every script and 
# every event...
#
# here is nothing you need to change...
# only if you want to add more keys...
# add them in separate block below the last block 
# so you wont get confused... ^-^ 
# for the mouse is now only 5 buttons... 
# if you want more buttons couse your mouse have more...
# then you'll have to wait till microsoft update there stuff... ^-^
#
# i'll try to make the mouse-wheel work...
# i cant promess anything... ^-^
#
# till next update you cann add more stuff or just use it as it is atm...
#
# in the next release will be hopefully the mouse-wheel (not sure though)
# and the joy-stick/pad buttons... 
# but before that i'll have to reasearch a little about that... ^-^
#==============================================================================
module Keyboard
	
  GetKeyState = Win32API.new("user32","GetAsyncKeyState",['i'],'i')
  GetKeyboardState = Win32API.new("user32","GetKeyState",['i'],'i')
  GetSetKeyState = Win32API.new("user32","SetKeyboardState",['i'],'i')
  
  module_function
  
  def keyboard(rkey)
	GetKeyState.call(rkey) & 0x01 == 1  #
  end
  
  def key(rkey, key = 0)
	GetKeyboardState.call(rkey) & 0x01 == key #
  end
  USED_KEYS = [
  Keys::A,
  Keys::B,
  Keys::C,
  Keys::D,
  Keys::E,
  Keys::F,
  Keys::G,
  Keys::H,
  Keys::I,
  Keys::J,
  Keys::K,
  Keys::L,
  Keys::M,
  Keys::N,
  Keys::O,
  Keys::P,
  Keys::Q,
  Keys::R,
  Keys::S,
  Keys::T,
  Keys::U,
  Keys::V,
  Keys::W,
  Keys::X,
  Keys::Y,
  Keys::Z,
  Keys::SPACE,
  Keys::NUM_DIVIDE,
  Keys::SEMI_COLON,
  Keys::EQUAL,
  Keys::COMMA,
  Keys::DASH,
  Keys::SLASH,
  Keys::ACCENT,
  Keys::OPEN_BRACKET,
  Keys::F_SLASH,
  Keys::CLOSE_BRACKET,
  Keys::PERIOD,
  Keys::N_0,
  Keys::N_1,
  Keys::N_2,
  Keys::N_3,
  Keys::N_4,
  Keys::N_5,
  Keys::N_6,
  Keys::N_7,
  Keys::N_8,
  Keys::N_9,
  Keys::NUM_0,
  Keys::NUM_1,
  Keys::NUM_2,
  Keys::NUM_3,
  Keys::NUM_4,
  Keys::NUM_5,
  Keys::NUM_6,
  Keys::NUM_7,
  Keys::NUM_8,
  Keys::NUM_9,
  Keys::RETURN,
  Keys::SHIFT,
  Keys::ESCAPE,
  Keys::QUOTE,
  Keys::SNAPSHOT
  ]
			   

  module_function
  
  def check(key)
	 Win32API.new("user32","GetAsyncKeyState",['i'],'i').call(key) & 0x01 == 1  
   # key 0
  end
   
  def trigger(key)
	return @used_i.include?(key)
  end
   
  def pressed(key)
	return true unless Win32API.new("user32","GetKeyState",['i'],'i').call(key).between?(0, 1)
	return false
  end
  
  def update
	@used_i = []
	for i in USED_KEYS
	  x = check(i)
	  if x == true
		@used_i.push(i)
	  end
	end
  end
  
end