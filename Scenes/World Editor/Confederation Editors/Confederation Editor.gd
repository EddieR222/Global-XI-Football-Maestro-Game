extends GraphNode

@export var selected_index: int = -1;
@export var confed: Confederation;
#@export var tot_terr_count: int;


signal graphnode_selected(confed_id: int);
	
"""
This function allows another scene to get the territory info that is currently selected
"""
func get_selected_territory() -> Territory:
	var selected_territory: Territory = confed.Territory_List[selected_index];
	return selected_territory;
	
func set_selected_territory(t: Territory) -> void:
	confed.Territory_List[selected_index] = t;
	
func get_territory_dict() -> Dictionary:
	return confed.Territory_List;
	
func set_confed_level(level: int):
	print("Level Received: " + str(level))
	confed.Level = level;
	
	var level_label: Label= get_node("HBoxContainer2/Label");
	level_label.text = "Level: " + str(confed.Level);
	
"""
These functions handle signls from within scene
"""

func _on_add_territory_pressed():
	# Add a blank territory item to ItemList
	var texture: CompressedTexture2D = load("res://Images/icon.svg");
	var index: int = $HBoxContainer/ItemList.add_item("Territory", texture, true);
	
	# For the item in the ItemList, we add a territory to the territory dictionary
	var default_territory: Territory = Territory.new();
	default_territory.Territory_Name = "Territory"
	
	# Here we want to set the Territory ID as the next value
	var node: GraphEdit = get_node("../Confed Edit");
	var graph: Graph = node.world_map;

	
	confed.Territory_List[index] = default_territory;
	
	# Emit signal as button press counts as GraphNode selected
	graphnode_selected.emit(confed.ID);


func _on_delete_territory_pressed():
	# Make Confirmation Popup Visisble
	$ConfirmationDialog.visible = 1;
	
	# Emit signal as button press counts as GraphNode selected
	graphnode_selected.emit(confed.ID);


func delete_and_organize() -> void:
	# First we need to delete the territory from the dictionary
	var index:int  = selected_index;
	confed.Territory_List.erase(index);
	
	# Now we organize the list to keep it linear since thats how items will be 
	# after a item is deleted
	var curr_index: int = index;
	while curr_index + 1 in confed.Territory_List.keys():
		var temp_terr: Territory = confed.Territory_List[curr_index + 1];
		confed.Territory_List[curr_index] = temp_terr;
		curr_index += 1;
	confed.Territory_List.erase(curr_index); 
	
	# Now we simply deleted it from ItemList which automatically shifts everything down
	$HBoxContainer/ItemList.remove_item(index);
	selected_index = -1;
	
	reflect_territory_changes();
	
	
func reflect_territory_changes():
	#We first need to go through and update the ItemList
	for index: int in confed.Territory_List.keys():
		var curr_terr: Territory = confed.Territory_List[index];
		$HBoxContainer/ItemList.set_item_text(index, curr_terr.Territory_Name);
		var flag = curr_terr.Flag;
		var texture_normal;
		if flag != null:
			flag.decompress();
			texture_normal = ImageTexture.create_from_image(flag);
		else:
			var default_icon: CompressedTexture2D = load("res://Images/icon.svg");
			texture_normal = default_icon;
			
		$HBoxContainer/ItemList.set_item_icon(index, texture_normal);

"""
The function below will alphabetize and reorganize the dictionary
"""

func sort_items():
	pass


func _on_edit_territory_pressed():
	# Emit signal as button press counts as GraphNode selected
	graphnode_selected.emit(confed.ID);


func _on_item_list_item_selected(index):
	# Emit signal as button press counts as GraphNode selected
	graphnode_selected.emit(confed.ID);


func _on_line_edit_text_changed(new_text):
	# Emit signal as button press counts as GraphNode selected
	graphnode_selected.emit(confed.ID);


func _on_gui_input(event):
	# Emit signal as button press counts as GraphNode selected
	graphnode_selected.emit(confed.ID);
