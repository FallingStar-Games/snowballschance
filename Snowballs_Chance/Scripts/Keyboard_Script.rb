#-------------------------------------------
# Keyboard script (part 1)
# By Cybersam
#---------------------------------------------


module Keys
  
  NULL   = 0x00		# NULL Value
  
  
  MOUSE_LEFT   = 0x01		# left mouse button
  MOUSE_RIGHT  = 0x02		# right mouse button
  MOUSE_MIDDLE = 0x04		# middle mouse button
  
  BACK	  = 0x08		# BACKSPACE key
  TAB	   = 0x09		# TAB key
  RETURN	= 0x0D		# ENTER key
  SHIFT	 = 0x10		# SHIFT key
  PAUSE	 = 0x13		# PAUSE key
  ESCAPE	= 0x1B		# ESC key
  SPACE	 = 0x20		# SPACEBAR
  
  PAGEUP	= 0x21		# PAGE UP key
  PAGEDOWN  = 0x22		# PAGE DOWN key
  END_	  = 0x23		# END key
  HOME	  = 0x24		# HOME key
  
  UP	 = 0x26		# UP ARROW key
  DOWN   = 0x28		# DOWN ARROW key
  LEFT   = 0x25		# LEFT ARROW key
  RIGHT  = 0x27		# RIGHT ARROW key
  
  SELECT	= 0x29		# SELECT key
  PRINT	 = 0x2A		# PRINT key
  SNAPSHOT  = 0x2C		# PRINT SCREEN key
  INSERT	= 0x2D		# INS key
  DELETE	= 0x2E		# DEL key
  
  N_0		 = 0x30		# 0 key
  N_1		 = 0x31		# 1 key
  N_2		 = 0x32		# 2 key
  N_3		 = 0x33		# 3 key
  N_4		 = 0x34		# 4 key
  N_5		 = 0x35		# 5 key
  N_6		 = 0x36		# 6 key
  N_7		 = 0x37		# 7 key
  N_8		 = 0x38		# 8 key
  N_9		 = 0x39		# 9 key
  
  A		 = 0x41		# A key
  B		 = 0x42		# B key
  C		 = 0x43		# C key
  D		 = 0x44		# D key
  E		 = 0x45		# E key
  F		 = 0x46		# F key
  G		 = 0x47		# G key
  H		 = 0x48		# H key
  I		 = 0x49		# I key
  J		 = 0x4A		# J key
  K		 = 0x4B		# K key
  L		 = 0x4C		# L key
  M		 = 0x4D		# M key
  N		 = 0x4E		# N key
  O		 = 0x4F		# O key
  P		 = 0x50		# P key
  Q		 = 0x51		# Q key
  R		 = 0x52		# R key
  S		 = 0x53		# S key
  T		 = 0x54		# T key
  U		 = 0x55		# U key
  V		 = 0x56		# V key
  W		 = 0x57		# W key
  X		 = 0x58		# X key
  Y		 = 0x59		# Y key
  Z		 = 0x5A		# Z key
  
  LWIN	  = 0x5B		# Left Windows key (Microsoft Natural keyboard) 
  RWIN	  = 0x5C		# Right Windows key (Natural keyboard)
  APPS	  = 0x5D		# Applications key (Natural keyboard)
  
  NUM_0   = 0x60		# Numeric keypad 0 key
  NUM_1   = 0x61		# Numeric keypad 1 key
  NUM_2   = 0x62		# Numeric keypad 2 key
  NUM_3   = 0x63		# Numeric keypad 3 key
  NUM_4   = 0x64		# Numeric keypad 4 key
  NUM_5   = 0x65		# Numeric keypad 5 key
  NUM_6   = 0x66		# Numeric keypad 6 key
  NUM_7   = 0x67		# Numeric keypad 7 key
  NUM_8   = 0x68		# Numeric keypad 8 key
  NUM_9	 = 0x69		# Numeric keypad 9 key
  
  NUM_MULTIPLY  = 0x6A		# Multiply key (*)
  NUM_ADD	   = 0x6B		# Add key (+)
  NUM_SEPARATOR = 0x6C		# Separator key
  NUM_SUBTRACT  = 0x6D		# Subtract key (-)
  NUM_DECIMAL   = 0x6E		# Decimal key
  NUM_DIVIDE	= 0x6F		# Divide key (/)
  
  CAPSLOCK  = 0x14		# CAPS LOCK key
  
  SEMI_COLON = 0xBA		#Semi-colon Key (;)
  EQUAL = 0xBB			 #Equal Key (=)
  COMMA = 0xBC			 #Comma Key (,)
  DASH = 0xBD			  #Dash Key (-)
  PERIOD = 0xBE			#Period Key (.)
  SLASH = 0xBF			 #Slash Key (/)
  ACCENT = 0xC0			#Accent Key (`)
  OPEN_BRACKET = 0xDB	  #Open Bracket ([)
  F_SLASH = 0xDC		   #Forward Slash (\)
  CLOSE_BRACKET = 0xDD	 #Close Bracket (])
  QUOTE = 0xDE		#Open Quote (')
  
  F1		= 0x70		# F1 key
  F2		= 0x71		# F2 key
  F3		= 0x72		# F3 key
  F4		= 0x73		# F4 key
  F5		= 0x74		# F5 key
  F6		= 0x75		# F6 key
  F7		= 0x76		# F7 key
  F8		= 0x77		# F8 key
  F9		= 0x78		# F9 key
  F10	   = 0x79		# F10 key
  F11	   = 0x7A		# F11 key
  F12	   = 0x7B		# F12 key
  
  NUMLOCK   = 0x90		# NUM LOCK key
  SCROLLOCK = 0x91		# SCROLL LOCK key
  
  L_SHIFT	  = 0xA0		# Left SHIFT key
  R_SHIFT	  = 0xA1		# Right SHIFT key
  L_CONTROL  = 0xA2		# Left CONTROL key
  R_CONTROL  = 0xA3		# Right CONTROL key
  L_ALT	  = 0xA4		# Left ALT key
  R_ALT	  = 0xA5		# Right ALT key
end