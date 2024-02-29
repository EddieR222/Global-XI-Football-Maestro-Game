extends Control


var FileName: String;



func _on_load_file_pressed():
	#We need to open the file dialog
	get_node("LoadWorldMap").visible = true;

func _on_load_world_map_file_selected(path):
	# Load the data saved in Disk
	var file_map : WorldMap = ResourceLoader.load(path) as WorldMap;
	
	#Change the FileName to display what the name of file was, so user can automatically
	#save changes easily
	FileName = path.get_file().get_basename();
	var file_name_edit: LineEdit = get_node("VBoxContainer/TitleBar/FileNameEdit");
	file_name_edit.text = FileName
	
	var item_list: ItemList = get_node("VBoxContainer/EditorBar/NationList");
	
	for confed: Confederation in file_map.Confederations.values():
		if confed.Level != 1:
			continue
		# Add Confed Item, its not selectable and Gray Background
		var confed_name = confed.Name;
		var index: int = item_list.add_item(confed_name, null, false);
		item_list.set_item_custom_bg_color(index, Color(0.486, 0.416, 0.4));
		
		for terr: Territory in confed.Territory_List.values():
			# Get Territory Name
			var terr_name = terr.Territory_Name;
			# Get Territory Flag or Icon
			var texture_normal
			var flag = terr.Flag;
			if flag != null:
				flag.decompress();
				texture_normal = ImageTexture.create_from_image(flag);
			else:
				var default_icon: CompressedTexture2D = load("res://Images/icon.svg");
				texture_normal = default_icon;
			# Add to item list
			var terr_index: int = item_list.add_item(terr_name, texture_normal, true);
			## Add to dictionary to keep track
			#terr_list[terr_index] = terr;
			
	#automatic_team_upload();
	
	pass
