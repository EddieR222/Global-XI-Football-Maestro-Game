extends GraphEdit

const CONFED_NODE : String = "res://Scenes/World Editor/Confederation Editors/Confederation Editor.tscn";
const TERRITORY_NODE : String = "res://Scenes/World Editor/Territory Editors/Territory Editor.tscn";



@export var confedaration_dict: Dictionary;
@export var territory_dict: Dictionary = {}

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
	world_nation_node.size = Vector2(1000, 500);
	
	
	# The Second Node is the World Club Tournaments
	var world_club_node: GraphNode = confed_node.instantiate();
	add_child(world_club_node);
	world_club_node.position_offset.x = get_viewport().get_mouse_position().x
	world_club_node.size = Vector2(150, 150);
	


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
	
	
