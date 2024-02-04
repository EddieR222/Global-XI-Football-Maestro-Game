extends GraphEdit

const CONFED_NODE : String = "res://Scenes/World Editor/Confederation Editors/Confederation Editor.tscn";
const TERRITORY_NODE : String = "res://Scenes/World Editor/Territory Editors/Territory Editor.tscn";



@export var confedaration_dict: Dictionary;
@export var territory_dict: Dictionary;
@export var node_tracker: Dictionary; 
@export var node_selected_num: int;



"""
Preload Nodes that we will instantiate later 
"""
@onready var confed_node: PackedScene = preload(CONFED_NODE);
@onready var terr_node: PackedScene = preload(TERRITORY_NODE);
	
# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Here we want to set up the Global Nodes. This is the base level for all confederation as this is the 
	# world node that contains all other confederations and nations
	var world_nation_node: GraphNode = confed_node.instantiate();
	add_child(world_nation_node);
	world_nation_node.position_offset.x = get_viewport().get_mouse_position().x
	world_nation_node.title = "World"
	
	# Now we connect buttons to here
	var edit_terr_button: Button = world_nation_node.get_node("HBoxContainer/MarginContainer/VBoxContainer/Edit Territory")
	edit_terr_button.pressed.connect(_on_edit_territory_pressed);
	world_nation_node.node_selected.connect(_on_node_selected);

	
	
	# We also have to instantiate the country editor, there will only be one in the entire document and it will follow 
	# the confederation node that activated it.
	var terr_edit_node: GraphNode = terr_node.instantiate();
	add_child(terr_edit_node);
	terr_edit_node.visible = 0;
	
	
	#Finally we add these nodes to the nodes tracker to be able to manpulate them later
	node_tracker[0] = world_nation_node
	node_tracker[1] = terr_edit_node


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#This means that is the territory editor is visible, we move it to edge of node that opened it
	if node_tracker[1].visible:
		node_tracker[1].position = node_tracker[0].position + Vector2(node_tracker[0].size.x, 0);


func compress_node_tracker(deleted_key: int):
	# Here we simply want to compress the dictionary so all nodes are in numerical order
	var index = deleted_key + 1;
	while index != node_tracker.size():
		var temp_node: GraphNode = node_tracker[index];
		node_tracker[index - 1] = temp_node;
		index += 1;
		
	node_tracker.erase(node_tracker.size() - 1); 
	

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
	var edit_terr_button: Button = new_node.get_node("HBoxContainer/MarginContainer/VBoxContainer/Edit Territory")
	edit_terr_button.pressed.connect(_on_edit_territory_pressed)
	new_node.node_selected.connect(_on_node_selected)
		
	# Now we add this node to the node_tracker so we can track it
	node_tracker[node_tracker.size()] = new_node;

	
func _on_node_selected():
	# First we need to find which node is selected by checking their selected variable
	for index in range(node_tracker.size()+1):
		var curr_node: GraphNode = node_tracker[index]
		if curr_node.selected == true:
			
			node_selected_num = index;
			print(node_selected_num)
			print(node_tracker.keys())
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
	
	# Now we delete it from dictionary
	compress_node_tracker(node_selected_num);
	
		
	
	
	
	
	pass # Replace with function body.
	
	
	
	
func _on_edit_territory_pressed():
	# This makes the territory editor visible
	node_tracker[1].visible = 1;
	
	# Now we set its position to the right side of the Confederation Node that opened it
	node_tracker[1].position = node_tracker[0].position + Vector2(node_tracker[0].size.x, 0);
	


	

