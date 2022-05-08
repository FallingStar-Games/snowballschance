# Extra Save Data script
# by coeleocanth
class Scene_Save < Scene_File
  #--------------------------------------------------------------------------
  # * Write Save Data
  #     file : write file object (opened)
  #--------------------------------------------------------------------------
  alias esd_write_save_data write_save_data
  def write_save_data(file)
    # Write all the standard save data
    esd_write_save_data(file)
    # construct extra save data, using a hash so there's some hope of
    # save file compatibility
    extra_save_data = {}
    extra_save_data[:diary] = $diary
    # Write the extra data to the end of the file
    Marshal.dump(extra_save_data, file)
  end
end

class Scene_Load < Scene_File
  #--------------------------------------------------------------------------
  # * Read Save Data
  #     file : file object for reading (opened)
  #--------------------------------------------------------------------------
  alias esd_read_save_data read_save_data
  def read_save_data(file)
    # Read all the standard save data
    esd_read_save_data(file)
    # Read extra save data, if present
    extra_save_data = Marshal.load(file) rescue {}
    # restore extra data that is present to the right places
    if extra_save_data[:diary]
      $diary = extra_save_data[:diary]
    end
    # Call any "refresh" functions here if needed
    # $game_party.refresh
  end
end

#------------------------------------------

class Interpreter
def new_page(text)
  i = 0
  while i < $diary.size
    if $diary[i] == "basicpaper" 
     $diary[i] = text
     popup(1, nil, 0)
     #set the jumppage here
     $game_variables[52]=i
     $game_temp.common_event_id = 34 #make the diary pop up
     break
   end
   i += 1
   $game_variables[10]+=1
  end
end
=begin
places where diary entries are changed:
-night 1
$diary[6]="campfiresong"  

also use
popup(1, nil, 0)


=end

#class end
end