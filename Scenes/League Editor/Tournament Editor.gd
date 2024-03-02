extends GraphEdit


""" Paths for Node Scenes """
const LEAGUE_NODE: String = "res://Scenes/League Editor/Tournament Nodes/LeagueNode.tscn"
const GROUPSTAGE_NODE: String = "res://Scenes/League Editor/Tournament Nodes/GroupStageNode.tscn"
const KNOCKOUT_NODE: String = "res://Scenes/League Editor/Tournament Nodes/KnockoutNode.tscn"
const SINGLE_KNOCKOUT_NODE: String ="res://Scenes/League Editor/Tournament Nodes/SingleKnockOutNode.tscn"


""" Packed Scenes of GraphNode """
@onready var league_node: PackedScene = preload(LEAGUE_NODE);
@onready var groupstage_node: PackedScene = preload(GROUPSTAGE_NODE);
@onready var knockout_node: PackedScene = preload(KNOCKOUT_NODE);
@onready var single_knockout_node: PackedScene = preload(SINGLE_KNOCKOUT_NODE);


""" Constants """
const NODE_SIZE: Vector2 = Vector2(600, 300);


""" Members """
var world_map: WorldMap;


# Called when the node enters the scene tree for the first time.
func _ready():
	configure_pop_menus()
	
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func configure_pop_menus() -> void:
	#First we need to set up the popup menu from the Add League Stage
	var add_node_popmenu: PopupMenu = get_node("../../../TitleBar/AddLeagueStage").get_popup()
	add_node_popmenu.id_pressed.connect(_on_add_stage_popmenu_item_selected);
	
	# Second we need to set up the add qualifying team popup
	

func _on_add_stage_popmenu_item_selected(index: int):
	match index:
		0: 
			print("GroupStage Added")
			var new_node: GraphNode = groupstage_node.instantiate();
			add_child(new_node)
			new_node.size = NODE_SIZE;
		1:
			print("League Added")
			var new_node: GraphNode = league_node.instantiate();
			add_child(new_node)
			new_node.size = NODE_SIZE;
		2:
			print("KnockOut Added")
			var new_node: GraphNode = knockout_node.instantiate();
			add_child(new_node)
			new_node.size = NODE_SIZE;
		3:
			print("Single Knockout Added")
			var new_node: GraphNode = single_knockout_node.instantiate();
			add_child(new_node)
			new_node.size = NODE_SIZE;
