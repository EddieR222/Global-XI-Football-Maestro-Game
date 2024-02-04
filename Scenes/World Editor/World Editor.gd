extends Control


@export var Filename: String;

"""
The following function will save the entire world_map to the file name choosen by the user
"""
func _on_save_file_pressed():
	var world_map: WorldMap = $"VBoxContainer/Confed Edit".world_map;
	
	ResourceSaver.save(world_map, "user://{filename}.tres".format({"filename": Filename}));
	


func _on_line_edit_text_changed(new_text: String):
	Filename = new_text;


func _on_load_file_pressed():
	$FileDialog.visible = true;
	

	
	
	
