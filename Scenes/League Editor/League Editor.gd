extends Control


@onready var graph_edit: GraphEdit = get_node("VBoxContainer/EditorBar/TabContainer/Tournament Editor");


var FileName: String;



func _on_load_file_pressed() -> void:
	#We need to open the file dialog
	get_node("LoadWorldMap").visible = true;

func _on_load_world_map_file_selected(path: String) -> void:
	# Load the data saved in Disk
	var file_map : WorldMap = ResourceLoader.load(path) as WorldMap;
	get_node("VBoxContainer/EditorBar/TabContainer/Tournament Editor").world_map = file_map;
	
	#Change the FileName to display what the name of file was, so user can automatically
	#save changes easily
	FileName = path.get_file().get_basename();
	var file_name_edit: LineEdit = get_node("VBoxContainer/TitleBar/FileNameEdit");
	file_name_edit.text = FileName
	
	var item_list: ItemList = get_node("VBoxContainer/EditorBar/NationList");

	
	# First we need to add all confederations as options
	var unselectable_item = item_list.add_item("Confederations", null, false);
	item_list.set_item_custom_bg_color(unselectable_item, Color(0.486, 0.416, 0.4));
	
	for confed: Confederation in file_map.Confederations.values():
		var confed_name = confed.Name;
		var index: int = item_list.add_item(confed_name, null, true);
		
		# Add to local list
		graph_edit.nation_list.set_item_metadata(index, confed);

	# Now we add all the territories
	unselectable_item = item_list.add_item("Territories", null, false);
	item_list.set_item_custom_bg_color(unselectable_item, Color(0.486, 0.416, 0.4));
	var terr_list = file_map.Confederations[0].Territory_List;
	for terr: Territory in terr_list.values():
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
		
		# Add to local list
		graph_edit.nation_list.set_item_metadata(terr_index, terr);
		
		
	# Add to dictionary to keep track
	graph_edit.world_map = file_map;


func _on_file_name_edit_text_changed(new_text: String) -> void:
	FileName = new_text;



# DONT FORGET METADATA!!!!!
func _on_texture_button_pressed():
	get_node("LeagueLogoInput").visible = true;
