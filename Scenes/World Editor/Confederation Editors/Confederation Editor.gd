extends GraphNode

@export var selected_index: int;
@export var confed_id: int;
@export var confed_name: String;
var territory_list: Dictionary;
@export var total_territory_num: int;
@export var confed_level: int;


signal graphnode_selected(confed_id: int);


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
"""
This function allows another scene to get the territory info that is currently selected
"""
func get_selected_territory() -> Territory:
	var selected_territory: Territory = territory_list[selected_index];
	return selected_territory;
	
func set_selected_territory(t: Territory) -> void:
	territory_list[selected_index] = t;
	
func get_territory_dict() -> Dictionary:
	return territory_list;
	
func set_confed_level(level: int):
	print("Level Received: " + str(level))
	confed_level = level;
	
	var level_label: Label= get_node("HBoxContainer2/Label");
	level_label.text = "Level: " + str(confed_level);
	
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
	territory_list[index] = default_territory;
	
	# Emit signal as button press counts as GraphNode selected
	graphnode_selected.emit(confed_id);


func _on_delete_territory_pressed():
	# Make Confirmation Popup Visisble
	$ConfirmationDialog.visible = 1;
	
	# Emit signal as button press counts as GraphNode selected
	graphnode_selected.emit(confed_id);


func delete_and_organize() -> void:
	# First we need to delete the territory from the dictionary
	var index:int  = selected_index;
	territory_list.erase(index);
	
	# Now we organize the list to keep it linear since thats how items will be 
	# after a item is deleted
	var curr_index: int = index;
	while curr_index + 1 in territory_list:
		var temp_terr: Territory = territory_list[curr_index + 1];
		territory_list[curr_index] = temp_terr;
		curr_index += 1;
	territory_list.erase(curr_index); 
	
	# Now we simply deleted it from ItemList which automatically shifts everything down
	$HBoxContainer/ItemList.remove_item(index);
	
	reflect_territory_changes();
	
	
func reflect_territory_changes():
	#We first need to go through and update the ItemList
	for index: int in territory_list.keys():
		var curr_terr: Territory = territory_list[index];
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








#func _on_gui_input(event):
	#print("GUI EVENT")
	#print(event)
	


func _on_edit_territory_pressed():
	# Emit signal as button press counts as GraphNode selected
	graphnode_selected.emit(confed_id);


func _on_item_list_item_selected(index):
	# Emit signal as button press counts as GraphNode selected
	graphnode_selected.emit(confed_id);


func _on_line_edit_text_changed(new_text):
	# Emit signal as button press counts as GraphNode selected
	graphnode_selected.emit(confed_id);


func _on_gui_input(event):
	# Emit signal as button press counts as GraphNode selected
	graphnode_selected.emit(confed_id);
