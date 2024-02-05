extends GraphEdit

const CONFED_NODE : String = "res://Scenes/World Editor/Confederation Editors/Confederation Editor.tscn";
const TERRITORY_NODE : String = "res://Scenes/World Editor/Territory Editors/Territory Editor.tscn";



@export var world_map: WorldMap = WorldMap.new()
@export var node_tracker: Dictionary; 
@export var node_selected_num: int;
@export var node_open_edit: int;



"""
Preload Nodes that we will instantiate later 
"""
@onready var confed_node: PackedScene = preload(CONFED_NODE);
@onready var terr_node: PackedScene = preload(TERRITORY_NODE);
	
# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Here we want to set up the Global Nodes. This is the base level for all confederation as this is the 
	# world node that contains all other confederations and nations
	var world_confed_node: GraphNode = confed_node.instantiate();
	add_child(world_confed_node);
	world_confed_node.position_offset.x = get_viewport().get_mouse_position().x
	
	
	var line_edit: LineEdit = world_confed_node.get_node("HBoxContainer2/LineEdit")
	line_edit.text = "World"
	line_edit.editable = false;
	var label: Label = world_confed_node.get_node("HBoxContainer2/Label")
	label.text = "Level: 0";
	enable_slots(world_confed_node)
	
	# Now we connect buttons to here
	connect_signals_from_confed_node(world_confed_node);
	
	# Now we make the confederation info for this node which will be stored in WorldMap;
	var world_confed_info = Confederation.new(); 
	world_confed_info.Level = 0;
	world_confed_info.Owner_ID = 0;
	world_confed_info.ID = 0;
	world_confed_info.Name = "World"
	world_map.Confederation_Dict[0] = world_confed_info;
	
	
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
		node_tracker[1].position = node_tracker[node_open_edit].position + Vector2(node_tracker[0].size.x, 0);


func compress_node_tracker(deleted_key: int):
	# Here we simply want to compress the dictionary so all nodes are in numerical order
	var index = deleted_key;
	while index + 1 in node_tracker:
		var temp_node: GraphNode = node_tracker[index + 1];
		node_tracker[index] = temp_node;
		index += 1;
	node_tracker.erase(index); 
	
	
	
func connect_signals_from_confed_node(node: GraphNode) -> void:
	# Here we connect the edit territory button to this scene
	var edit_terr_button: Button = node.get_node("HBoxContainer/MarginContainer/VBoxContainer/Edit Territory")
	edit_terr_button.pressed.connect(_on_edit_territory_pressed);
	
	# Here we connect the node selection to this scene
	#node.node_selected.connect(_on_node_selected_lol);
	
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
	
	# Now we connect this confederation node's "Edit Button" to this script. 
	connect_signals_from_confed_node(new_node);
		
	# Now we add this node to the node_tracker so we can track it
	node_tracker[node_tracker.size()] = new_node;
	
	# Make it by deault level 1
	var label: Label = new_node.get_node("HBoxContainer2/Label")
	label.text = "Level: 1";
	
	#Enable Slots for all added nodes
	enable_slots(new_node)
	

	
func _on_node_selected_lol():
	# First we need to find which node is selected by checking their selected variable
	for index in range(node_tracker.size()):
		var curr_node: GraphNode = node_tracker[index]
		if curr_node.selected == true:
			node_selected_num = index;
			print("Node Selected: " + str(node_selected_num))
			return
	
	# If we reach here, then no node is selected and we set node_selected_num to -1 to relfect that
	node_selected_num = -1;
	


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
	if not node_tracker[node_open_edit].territory_list.has(node_tracker[node_open_edit].selected_index):
		return	
	if node_open_edit != node_selected_num:
		return
	
	
	# This makes the territory editor visible
	node_tracker[1].visible = true;
	
	# Set open_node_edit as the currently selected node
	node_open_edit = node_selected_num;
	
	# Now we set its position to the right side of the Confederation Node that opened it
	node_tracker[1].position = node_tracker[node_open_edit].position + Vector2(node_tracker[node_open_edit].size.x, 0);
	
	# Now we need to display the previously saved territory information
	var previous_terr: Territory = node_tracker[node_open_edit].get_selected_territory();
	node_tracker[1].load_previous_territory_info(previous_terr);
	
func _on_confed_name_changed(new_name: String) -> void:
	world_map.Confederation_Dict[node_selected_num].Name = new_name;
	#print(world_map.Confederation_Dict[node_selected_num])
	
func _on_done_button_pressed():
	#Save territory info to required resources such as confed_node and world_map
	save_territory();
	
	# Now we make the edit territory node invisible
	node_tracker[1].visible = false;
	
func _on_territory_selected(index: int) -> void:
	#First we need to check if current node selected has terr edit open
	if node_open_edit != node_selected_num:
		print("Wrong node, no effect")
		return
	
	#Now we also have to check if edit territory is open
	if node_tracker[1].visible == false:
		print("Edit Territory Not Visible")
		return
		
	if node_tracker[node_open_edit].selected_index == -1:
		return
		
	# Now we know that the edit territory node is visible and we selected a territory
	# from the confed node that opened the territory node.
	#First we need to save current input from territory edit node
	save_territory();
	
	# Now we change the selected_index in the confed node
	node_tracker[node_open_edit].selected_index = index;
	
	#Finally, we load the selected territory info onto the edit territory node
	load_territory(index);
	
func _on_deleted_confirmed():
	node_tracker[1].visible = false;
	
	node_tracker[node_open_edit].delete_and_organize();
	
	
func print_territory(t: Territory):
	print(t.Territory_Name);
	print(t.CoTerritory_ID);
	print(t.CoTerritory_Name);
	print(t.Code);
	
	
	
func enable_slots(node: GraphNode):
	node.set_slot(0, true, 0, Color(1,1,1,1), true, 0, Color(0,1,0,1), null, null, true)
	
	return
	



func _on_connection_request(from_node, from_port, to_node, to_port):
	connect_node(from_node, from_port, to_node, to_port);
	


func _on_node_selected(node: Node):
	node_selected_num = node_tracker.find_key(node);
	print("Node Selected: " + str(node_selected_num));
	
