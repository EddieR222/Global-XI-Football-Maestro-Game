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
	

func _on_file_dialog_file_selected(path):
	var world_map : WorldMap = ResourceLoader.load(path);
	
	$"VBoxContainer/Confed Edit".world_map = world_map;
	
	for node: GraphNode in world_map.graph_nodes.values():
		var confed: Confederation = node.confed;
		for terr: Territory in confed.Territory_List.values():
			print(terr.Territory_Name);
		
		
