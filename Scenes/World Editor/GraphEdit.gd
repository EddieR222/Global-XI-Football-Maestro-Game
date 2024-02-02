extends GraphEdit

const CONFED_NODE : String = "res://Scenes/World Editor/Confederation Editors/Confederation Editor.tscn";
const TERRITORY_NODE : String = "res://Scenes/World Editor/Territory Editors/Territory Editor.tscn";



@export var confedaration_dict: Dictionary;
@export var territory_dict: Dictionary;
@export var node_tracker: Dictionary; 



"""
Preload Nodes that we will instantiate later 
"""
@onready var confed_node: PackedScene = preload(CONFED_NODE);
@onready var terr_node: PackedScene = preload(TERRITORY_NODE);
	
# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Here we want to set up the Global Nodes. These will be avaliable regardless of countries or clubs included
	# The First Node is the World National Tournaments
	var world_nation_node: GraphNode = confed_node.instantiate();
	add_child(world_nation_node);
	world_nation_node.position_offset.x = get_viewport().get_mouse_position().x

	
	
	# The Second Node is the World Club Tournaments
	var world_club_node: GraphNode = confed_node.instantiate();
	add_child(world_club_node);
	world_club_node.position_offset.x = get_viewport().get_mouse_position().x
	
	
	
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func gather_territory_info_edits():
	pass
	



"""
Everything Below Here is Signals Handlers
"""

# Called when we press the "ADD CONFEDERATION" button
func _on_add_confed_node_pressed():
	
	# Get Node from preloaded scene, and add to tree
	var new_node: GraphNode = confed_node.instantiate(); 
	add_child(new_node);
	new_node.position_offset.x = get_viewport().get_mouse_position().x
	
	# Now we connect this confederation node's edit button to this script. 
	var edit_terr_button: Button = new_node.get_node("HBoxContainer/MarginContainer/VBoxContainer/Edit Territory")
	edit_terr_button.pressed.connect(_on_edit_territory_pressed)
	
	
	
	
	
func _on_edit_territory_pressed():
	print("Edit Button Pressed")
	
	
