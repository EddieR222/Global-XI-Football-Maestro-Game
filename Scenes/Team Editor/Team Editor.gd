extends Control


func _on_load_file_pressed():
	$FileDialog.visible = true
	
func _on_file_dialog_file_selected(path: String):
	var file_map : WorldMap = ResourceLoader.load(path) as WorldMap;
	
	var item_list: ItemList = get_node("VBoxContainer/Editor Bar/Country List");
	
	for confed: Confederation in file_map.Confederations.values():
		if confed.Level != 1:
			continue
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
			item_list.add_item(terr_name, texture_normal, true);
	
