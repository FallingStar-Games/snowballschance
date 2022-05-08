#:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:
# [Xp] Longer Script Call
# Version: 1.01
# just put another script call after the first one and they'll all run in order 
# in a connected manner
#:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:
#==============================================================================
# ** Interpreter 
#------------------------------------------------------------------------------
#  This interpreter runs event commands. This class is used within the
#  Game_System class and the Game_Event class.
#==============================================================================

class Interpreter
  #-------------------------------------------------------------------
  # * Constant
  #-------------------------------------------------------------------
  SCRIPT_WAIT_RESULT = [:wait, FalseClass]
  #-------------------------------------------------------------------
  # * Script
  #-------------------------------------------------------------------
  def command_355
    script = @list[index = @index].parameters[0] + "\n"
    while [655, 355].include?(@list[@index + 1].code) do
      script += @list[@index += 1].parameters[0] + "\n"
    end
    wait = SCRIPT_WAIT_RESULT.include?(eval(script))    
    return wait ? !(@index = index) : true
  end  
end