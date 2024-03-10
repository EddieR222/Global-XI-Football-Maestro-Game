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

""" ItemLists """
# Nation List
@onready var nation_list: ItemList = get_node("../../NationList");
var nation_list_info: Dictionary; 
var nation_list_index: int = -1;

# League Pyramid List
@onready var league_pyramid: ItemList = get_node("../Territory League Pyramid/League Pyramid Area/League Pyramid")
var league_pyramid_info: Dictionary
var league_pyramid_index: int

# Tournament List
@onready var tournament_list: ItemList = get_node("../Territory Tournaments/Tournament List Area/Tournament List")
var tournament_list_info: Dictionary;
var tournament_list_index: int; 


""" Constants """
const NODE_SIZE: Vector2 = Vector2(600, 300);


""" Members """
var world_map: WorldMap;





# Called when the node enters the scene tree for the first time.
func _ready():
	#configure_pop_menus()
	pass

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


func load_tournaments(source) -> void:
	# First we clear the current list
	league_pyramid.clear();
	tournament_list.clear();
	
	
	
	var leagues: Dictionary
	var tournaments: Dictionary
	var super_cup_index: int;
	var league_cup: int;
	if source is Territory:
		# Load needed variables
		leagues= source.Leagues;
		tournaments = source.Tournaments;
		super_cup_index= source.Super_Cup;
		league_cup = source.League_Cup;
	elif source is Confederation:
		leagues = source.Confed_Leagues;
		tournaments = source.Confed_Tournaments;
		super_cup_index = source.Super_Cup;
		league_cup = source.Cup;
		
		
	# Now we need to load them into the needed itemlists
	# First we load the league pyramid
	for league: Tournament in leagues.values():
		# Get Tournament Name
		var league_name = league.Name;
		# Get Tournament Logo
		var texture_normal
		var logo = league.Logo;
		if logo != null:
			logo.decompress();
			texture_normal = ImageTexture.create_from_image(logo);
		else:
			var default_icon: CompressedTexture2D = load("res://Images/icon.svg");
			texture_normal = default_icon;
		# Add it to item list
		var index = league_pyramid.add_item(league_name, texture_normal, true);
		# Save it to local list  
		league_pyramid_info[index] = league;
		
	# Second we load the other tournaments
	for tournament: Tournament in tournaments.values():
		# Get Tournament Name
		var league_name = tournament.Name;
		# Get Tournament Logo
		var texture_normal
		var logo = tournament.Logo;
		if logo != null:
			logo.decompress();
			texture_normal = ImageTexture.create_from_image(logo);
		else:
			var default_icon: CompressedTexture2D = load("res://Images/icon.svg");
			texture_normal = default_icon;
		# Add it to item list
		var index = league_pyramid.add_item(league_name, texture_normal, true);
		#Save to local list
		tournament_list_info[index] = tournament;
		
		#We have to highlight super cup and leagues cup
		if index == super_cup_index:
			league_pyramid.set_item_custom_bg_color(index, Color(0.486, 0.416, 0.4));
		elif index == league_cup:
			league_pyramid.set_item_custom_bg_color(index, Color(0.486, 0.416, 0.0));
		
	
		

""" Functions for when user selects in an item list """
func _on_nation_list_item_selected(index: int) -> void:
	# Change index for nation list
	nation_list_index = index
	
	# Load the New Selected Territory's or Confederation's tournament
	load_tournaments(nation_list_info[index]);

func _on_league_pyramid_item_selected(index: int) -> void:
	# Change index for league pyramid
	league_pyramid_index = index

func _on_tournament_list_item_selected(index: int) -> void:
	# Change the index for tournament list
	tournament_list_index = index	



""" Item Lists Addition and Deletion """
func _on_add_league_level_pressed():
	# Create a new Tournament for the league
	var new_tour: Tournament = Tournament.new();
	new_tour.Name = "New Tournament"
	
	
	
	
	# Add it to the league pyramid
	var default_icon: CompressedTexture2D = load("res://Images/icon.svg");
	var index = league_pyramid.add_item("New Tournament", default_icon, true);
	league_pyramid_info[index] = new_tour;

func _on_delete_league_level_pressed():
	# Remove it from local dict
	league_pyramid_info.erase(league_pyramid_index);

	# Remove it from league pyramid item list
	league_pyramid.remove_item(league_pyramid_index);

