extends GraphEdit

const CONFED_NODE : String = "res://Scenes/World Editor/Confederation Editors/Confederation Editor.tscn";
const TERRITORY_NODE : String = "res://Scenes/World Editor/Territory Editors/Territory Editor.tscn";



@export var world_map: WorldMap = WorldMap.new()
@export var node_tracker: Dictionary; 
@export var node_selected_num: int = -1
@export var node_open_edit: int = -1



"""
Preload Nodes that we will instantiate later 
"""
@onready var confed_node: PackedScene = preload(CONFED_NODE);
@onready var terr_node: PackedScene = preload(TERRITORY_NODE);
	
# Called when the node enters the scene tree for the first time.
func _ready():
	
	# We want to establish the world node and ensure it has the right properties
	var world_confed_node: GraphNode = establish_world_node();
	
	# We also have to instantiate the country editor, there will only be one in the entire document and it will follow 
	# the confederation node that activated it.
	var terr_edit_node: GraphNode = terr_node.instantiate();
	add_child(terr_edit_node);
	terr_edit_node.visible = 0;
	
	# Now we connect the territory edit node to the correct signals here
	connect_signals_from_territory_node(terr_edit_node);
	
	#Finally we add these nodes to the nodes tracker to be able to manpulate them later
	node_tracker[0] = world_confed_node
	node_tracker[1] = terr_edit_node


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#This means that is the territory editor is visible, we move it to edge of node that opened it
	if node_tracker[1].visible:
		node_tracker[1].position = node_tracker[node_open_edit].position + Vector2(node_tracker[0].size.x, 0) * zoom;
		
func establish_world_node() -> GraphNode:
	#First we simply instantiate the Node into the scene tree
	var world_confed_node: GraphNode = confed_node.instantiate();
	add_child(world_confed_node);
	world_confed_node.position_offset.x = get_viewport().get_mouse_position().x
	
	# Now we name this Node as "World" and ensure this isn't changeable
	var line_edit: LineEdit = world_confed_node.get_node("HBoxContainer2/LineEdit")
	line_edit.text = "World"
	line_edit.editable = false;
	
	# Now we Edit the Level Number Label to show this node is the base node: "Level: 0"
	var label: Label = world_confed_node.get_node("HBoxContainer2/Label")
	label.text = "Level: 0";
	
	# Now we enable the slots, simialr to other nodes but this one can't have connections OUT of but only IN
	world_confed_node.set_slot(0, true, 0, Color(0,1,0,1), false, 0,  Color(1,0,0,1), null, null, true)
	
	
	
	# Here we connect all needed signals
	connect_signals_from_confed_node(world_confed_node);
	
	
	# Now we make the confederation info for this node which will be stored in WorldMap;
	var world_confed_info = Confederation.new(); 
	world_confed_info.Level = 0;
	world_confed_info.Owner_ID = 0;
	world_confed_info.ID = 0;
	world_confed_info.Name = "World"
	world_map.Confederation_Dict[0] = world_confed_info;
	
	# Update the info into GraphNode info
	world_confed_node.confed_level = 0;
	world_confed_node.confed_id = 0
	world_confed_node.confed_name = "World"
	
	
	# Finally return the world node
	return world_confed_node
	
func compress_node_tracker(deleted_key: int):
	# Here we simply want to compress the dictionary so all nodes are in numerical order
	var index: int = deleted_key;
	while index + 1 in node_tracker:
		var temp_node: GraphNode = node_tracker[index + 1];
		node_tracker[index] = temp_node;
		index += 1;
	node_tracker.erase(index); 
	
	# Here we also want to compress the dictionary in world_map
	var idx: int = deleted_key;
	while idx + 1 in world_map.Confederation_Dict:
		var temp_confed: Confederation = world_map.Confederation_Dict[idx + 1];
		temp_confed.ID = idx
		world_map.Confederation_Dict[idx] = temp_confed;
		idx += 1;
	world_map.Confederation_Dict.erase(idx);
	
	
"""
The following function can be used to propagate the countries up the confederation tree
"""	
func propagate_country_list(node: GraphNode):
	# Get the list of territories
	var confed: Confederation = world_map.Confederation_Dict[node.confed_id];
	var territories: Dictionary = node.territory_list;
	
	# Now we place each territory into the owner node's territory list
	var owner_id: int = confed.Owner_ID;
	var curr_id: int = confed.ID;
	
	while owner_id != 0 or curr_id != 0:
		var owner_confed: Confederation = world_map.Confederation_Dict[owner_id];
		var owner_node: GraphNode = node_tracker[owner_id];
		for terr: Territory in territories.values():
			var itemlist: ItemList = owner_node.get_node("HBoxContainer/ItemList");
			itemlist.add_item(terr.Territory_Name, null, true);
			var new_index: int = owner_node.territory_list.size(); 
			owner_node.territory_list[new_index] = terr;
		world_map.Confederation_Dict[owner_id].Territory_List = owner_node.territory_list;
		confed = owner_confed
		curr_id = owner_id
		owner_id = owner_confed.Owner_ID
		owner_node.reflect_territory_changes();
	
	
	
	
func connect_signals_from_confed_node(node: GraphNode) -> void:
	# Here we connect the mouse_entered signal so selection is based on the player mouse entering the node area
	# This allows buttons or text typing to alert the selection and not mandate the user from having to select the node itself
	node.graphnode_selected.connect(_on_node_entered);
	
	# Here we connect the edit territory button to this scene
	var edit_terr_button: Button = node.get_node("HBoxContainer/MarginContainer/VBoxContainer/Edit Territory")
	edit_terr_button.pressed.connect(_on_edit_territory_pressed);

	# Here we connect the line Edit text to this scene
	var confed_name_edit: LineEdit = node.get_node("HBoxContainer2/LineEdit");
	confed_name_edit.text_submitted.connect(_on_confed_name_changed);
	
	#Here we connect the selection of an itemlist to this scene
	var itemlist: ItemList = node.get_node("HBoxContainer/ItemList");
	itemlist.item_selected.connect(_on_territory_selected);
	
	#Here we connect the delete territory button
	var delete_confirmation = node.get_node("ConfirmationDialog")
	delete_confirmation.confirmed.connect(_on_deleted_confirmed);
	
func connect_signals_from_territory_node(node: GraphNode) -> void:
	# Here we connect the "Done" button from territory node
	var done_button: Button = node.get_node("VBoxContainer2/Done");
	done_button.pressed.connect(_on_done_button_pressed);
	
	
	

"""
The following functions can be used to save and load territory information from
the territory edit node
"""
func save_territory() -> void:
	# First we need to grab the current territory information displayed on the 
	# territory edit node
	var curr_territory: Territory = node_tracker[1].get_territory();
	print_territory(curr_territory);
	# Now we save this territory info to confed node local territory dictionary
	node_tracker[node_open_edit].set_selected_territory(curr_territory);
	
	# Now we save the localy saved data into the world_map resource
	world_map.Confederation_Dict[node_open_edit].Territory_List = node_tracker[node_open_edit].get_territory_dict();
	
	# Now we need to display the changes in ItemList
	node_tracker[node_open_edit].reflect_territory_changes();
	propagate_country_list(node_tracker[node_open_edit]);
	
func load_territory(selected_index: int ) -> void:
	# First we grab the territory info
	var node_edit: GraphNode = node_tracker[node_open_edit];
	var selected_terr: Territory = node_edit.territory_list[selected_index];
	
	# Now we call the group in territory edit node in order to display this information
	node_tracker[1].load_previous_territory_info(selected_terr);
	
"""
The following are Signal Handlers that pertain to the addition and deletion of confederations nodes
"""

# Called when we press the "ADD CONFEDERATION" button
func _on_add_confed_node_pressed():
	
	# Get Node from preloaded scene, and add to tree
	var new_node: GraphNode = confed_node.instantiate(); 
	add_child(new_node);
	new_node.position_offset.x = get_viewport().get_mouse_position().x
	
	# Now we connect all needed signals 
	connect_signals_from_confed_node(new_node);
		
	# Now we add this node to the node_tracker so we can track it
	node_tracker[node_tracker.size()] = new_node;
	
	# We also want to save this confederation data into the world_map
	var new_confed: Confederation = Confederation.new();
	new_confed.ID = node_tracker.size() - 1;
	new_confed.Level = 1;
	new_confed.Name = "New Confederation"
	world_map.Confederation_Dict[node_tracker.size()-1] = new_confed
	new_node.confed_id = node_tracker.size() - 1;
	new_node.confed_name = "New Confederation"
	new_node.confed_level = 1;

	# Make it by deault level 1
	var label: Label = new_node.get_node("HBoxContainer2/Label")
	label.text = "Level: 1";
	
	#Enable Slots for all added nodes
	enable_slots(new_node)
	
func _on_delete_node_pressed():
	match node_selected_num:
		-1:
			print("No Node selected, please select one to delete")
			return
		0:
			print("Can not delete World Node, please select another to delete")
			return
		1:
			print("Can not delete Territory Editor Node, please select another to delete")
	
		
	var node_to_delete: GraphNode = node_tracker[node_selected_num];
	node_tracker.erase(node_selected_num)
	node_to_delete.queue_free();
	
	# Now we correct the dictionary to keep consitent linear keys 
	compress_node_tracker(node_selected_num);
	
""" 
The following function handles 
"""
func _on_edit_territory_pressed():
	#First we check that the territory edit isn't currently open, if it is open
	# then we do nothing as the user needs to close previous instance by pressing the 
	# "Done" button
	if node_tracker[1].visible == true:
		return
	
	# Now we check if node_open_edit is equal to -1, if yes, then we know that we are allowed to open the edit territory scene again
	if node_open_edit != -1 and node_open_edit != node_selected_num:
		return
		
		
	# Set open_node_edit as the currently selected node
	node_open_edit = node_selected_num;
	
	
	if not node_tracker[node_open_edit].territory_list.has(node_tracker[node_open_edit].selected_index):
		return	
	
	# This makes the territory editor visible
	node_tracker[1].visible = true;


	# Now we set its position to the right side of the Confederation Node that opened it
	node_tracker[1].position = node_tracker[node_open_edit].position + Vector2(node_tracker[node_open_edit].size.x, 0);
	
	# Now we need to display the previously saved territory information
	var previous_terr: Territory = node_tracker[node_open_edit].get_selected_territory();
	node_tracker[1].load_previous_territory_info(previous_terr);
	
# This function changes the name of the confederation when the uses changes the input in the LineEdit for the confederation Node
func _on_confed_name_changed(new_name: String) -> void:
	# First we get the confederation ID to track which node we will be changing
	var confederation = 0;
	world_map.Confederation_Dict[node_selected_num].Name = new_name;
	
	

"""
This function runs when the done button is pressed
It saves the territory information and closes the Edit Territory Editor
"""
func _on_done_button_pressed():
	#Save territory info to required resources such as confed_node and world_map
	save_territory();
	
	# Now we make the edit territory node invisible
	node_tracker[1].visible = false;
	
	# Now we set node_open_edit to -1 to show that node_tracker isn't open and we are allowed to changed
	node_open_edit = -1
	
"""
This function switches the country info displayed on the Edit Territory Editor depending on which country the user selected.
Before switching, this functions saves the territory info being displayed and loads the next selected one 
"""
func _on_territory_selected(index: int) -> void:
	#First we need to check if current node selected has terr edit open
	
	if node_tracker[1].visible == true and node_open_edit == node_selected_num:
	# Now we know that the edit territory node is visible and we selected a territory
	# from the confed node that opened the territory node.
		#First we need to save current input from territory edit node
		save_territory();
		
		# Now we change the selected_index in the confed node
		node_tracker[node_open_edit].selected_index = index;
		
		#Finally, we load the selected territory info onto the edit territory node
		load_territory(index);
	else:
		node_tracker[node_selected_num].selected_index = index;	
	
"""
This function runs when the user clicks "Delete Territory - " Button and currently has a counry selected
"""
func _on_deleted_confirmed():
	# Makes the Edit Territory Editor Invisible
	node_tracker[1].visible = false;
	
	# Calls the method specific to the node to delete the territory from it's list and organize its list (similar to compress and organize) 
	node_tracker[node_selected_num].delete_and_organize();
	
	
func print_territory(t: Territory):
	print(t.Territory_Name);
	print(t.CoTerritory_ID);
	print(t.CoTerritory_Name);
	print(t.Code);
	
	

"""
The function below is used to enable slots for the confederation nodes. This allows connection between nodes
"""
func enable_slots(node: GraphNode):
	node.set_slot(0, true, 0, Color(0,1,0,1), true, 0,  Color(1,0,0,1), null, null, true)
	return
	
	
# This function handles connections between Confederation Nodes 

func _on_connection_request(from_node, from_port, to_node, to_port):
	# This ensures a player doesn't try to connect a node to itself (which doesn't make sense)
	if from_node == to_node:
		return
		
	
	
	
	# find_node(from_node)
	connect_node(from_node, from_port, to_node, to_port);
	
	print(from_node + "->" + to_node)
	
	
	# Here we get the nodes in order to calculate different things
	var curr_node_path: NodePath = NodePath(from_node);
	var owner_node_path: NodePath = NodePath(to_node);
	var curr_node: GraphNode = get_node(curr_node_path);
	var owner_node: GraphNode = get_node(owner_node_path);
	
	
	print(str(curr_node.confed_name) + "->" + str(owner_node.confed_name))
	
	#  Now we get the level that the from_node should be
	var owner_level = owner_node.confed_level
	if owner_level == 10:
		#TODO: Have some way to notify the user of this
		print("Can't Continue")
		return
	curr_node.set_confed_level(owner_level + 1);
	
	# Update Owner ID in Confed Node
	world_map.Confederation_Dict[curr_node.confed_id].Level = owner_level + 1;
	world_map.Confederation_Dict[curr_node.confed_id].Owner_ID = owner_node.confed_id;
	
	# Now we put the territory list into the owner confederation
	propagate_country_list(curr_node);

"""
The two functions belows essentially decide and change the needed values when a GraphNode is selected or entered.
"""
func _on_node_entered(confed_id: int):
	# Update Node_Selected_NUm
	node_selected_num = confed_id
	
	# Unselect every GraphNode in list
	for node: GraphNode in node_tracker.values():
		node.selected = false
	
		
	# Finally set new entered node as selected
	node_tracker[node_selected_num].selected = true

func _on_node_selected(node: GraphNode):
	node_selected_num = node_tracker.find_key(node)

func _on_disconnection_request(from_node, from_port, to_node, to_port):
	disconnect_node(from_node, from_port, to_node, to_port);
