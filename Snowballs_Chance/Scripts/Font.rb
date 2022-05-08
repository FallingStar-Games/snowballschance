#---------------------------------------
#
# Different Font
#
#---------------------------------------

class Font
alias font_fix_initialize initialize

def initialize
font_fix_initialize
$defaultfont =  ["BPixelDouble","PlopDump","Comic Sans MS"]# Font
self.name = $defaultfont
self.size = 20 # Size

$defaultfonttype = self.name
$defaultfontsize = self.size

end

end
