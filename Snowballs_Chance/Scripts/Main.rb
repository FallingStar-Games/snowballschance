#==============================================================================
# ** Main
#------------------------------------------------------------------------------
#  After defining each class, actual processing begins here.
#==============================================================================

begin
  #Graphics.frame_rate = 60 
  #changes framerate to 60, makes everything hella fast
  
  # Prepare for transition
  Graphics.freeze
  # Make scene object (title screen)
  $scene = Scene_Splash.new
  # Call main method as long as $scene is effective
  while $scene != nil
    $scene.main
  end
  # Fade out
  Graphics.transition(20)
rescue Errno::ENOENT
  # Supplement Errno::ENOENT exception
  # If unable to open file, display message and end
  filename = $!.message.sub("No such file or directory - ", "")
  print("Unable to find file #{filename}.")
end
