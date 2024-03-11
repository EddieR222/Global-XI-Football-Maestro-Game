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
enum DAYS {JANUARY = 31, FEBRUARY = 28, MARCH = 31, APRIL = 30, MAY = 31, JUNE = 30, JULY = 31, AUGUST = 31, SEPTEMBER = 30, OCTOBER = 31, NOVEMBER = 30, DECEMBER = 31};


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
		var index = tournament_list.add_item(league_name, texture_normal, true);
		#Save to local list
		tournament_list_info[index] = tournament;
		
		#We have to highlight super cup and leagues cup
		if index == super_cup_index:
			tournament_list.set_item_custom_bg_color(index, Color(0.486, 0.416, 0.4));
		elif index == league_cup:
			tournament_list.set_item_custom_bg_color(index, Color(0.486, 0.416, 0.0));
		

""" Functions for when user selects in an item list """
func _on_nation_list_item_selected(index: int) -> void:
	# Change index for nation list
	nation_list_index = index
	
	# Load the New Selected Territory's or Confederation's tournament
	load_tournaments(nation_list_info[index]);

func _on_league_pyramid_item_selected(index: int) -> void:
	# Change index for league pyramid
	league_pyramid_index = index
	
	# Display selected league's info
	get_tree().call_group("League_Info", "league_selected", league_pyramid_info[league_pyramid_index]);

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
	
	# Save it to the terr/confed selected
	var sink = nation_list_info[nation_list_index];
	if sink is Territory:
		sink.Leagues[index] = new_tour
	elif sink is Confederation:
		sink.Confed_Leagues[index] = new_tour
		
	organize_tournaments();

func _on_delete_league_level_pressed():
	# Remove it from local dict
	league_pyramid_info.erase(league_pyramid_index);

	# Remove it from league pyramid item list
	league_pyramid.remove_item(league_pyramid_index);

func _on_add_tournament_pressed() -> void:
	# Create a new Tournament for the league
	var new_tour: Tournament = Tournament.new();
	new_tour.Name = "New Tournament"
	
	
	
	
	# Add it to the league pyramid
	var default_icon: CompressedTexture2D = load("res://Images/icon.svg");
	var index = tournament_list.add_item("New Tournament", default_icon, true);
	tournament_list_info[index] = new_tour;
	
	# Save it to the terr/confed selected
	var sink = nation_list_info[nation_list_index];
	if sink is Territory:
		sink.Tournaments[index] = new_tour
	elif sink is Confederation:
		sink.Confed_Tournaments[index] = new_tour

func organize_tournaments() -> void:
	# We need to gather all tournaments into an array
	var all_tournaments: Array = [];
	for confed: Confederation in world_map.Confederations.values():
		var leagues: Dictionary = confed.Confed_Leagues;
		for tour: Tournament in leagues.values():
			all_tournaments.push_back(tour)
		var tournaments: Dictionary = confed.Confed_Tournaments;
		for tour: Tournament in tournaments.values():
			all_tournaments.push_back(tour)
			
	for terr in nation_list_info.values():
		if terr is Confederation:
			continue
		var leagues: Dictionary = terr.Leagues;
		for tour: Tournament in leagues.values():
			all_tournaments.push_back(tour)
		var tournaments: Dictionary = terr.Tournaments; 
		for tour: Tournament in tournaments.values():
			all_tournaments.push_back(tour)

	# Now we sort all these tournaments by name
	all_tournaments.sort_custom(func(a, b): return a.Name < b.Name);
	
	# Now we rewrite the IDs and place into sorted dictionary
	var index: int = 0;
	for tournament: Tournament in all_tournaments:
		tournament.ID = index
		index += 1;



""" League Pyramid Editor Inputs Singals """
# League Logo Texture Button
func _on_league_logo_input_file_selected(path: String) -> void:
	# Load Image of Territory Flag
	var logo: Image = Image.load_from_file(path);
	logo.resize(150, 150, 2);
	var flag_texture: ImageTexture = ImageTexture.create_from_image(logo);
	
	# Change Texture of Texture Button to reflect change
	get_node("../Territory League Pyramid/Tournament Edit Area/Header/TextureButton").texture_normal = flag_texture
	
	# Save Image into Territory Class
	logo.compress(Image.COMPRESS_BPTC);
	league_pyramid_info[league_pyramid_index].Logo = logo;
	
# League Name LineEdit
func _on_league_name_text_changed(new_text: String) -> void:
	league_pyramid_info[league_pyramid_index].Name = new_text;
	
# League Importance SpinBox
func _on_spin_box_value_changed(value: int) -> void:
	league_pyramid_info[league_pyramid_index].Importance = value;

# League Host Country LineEdit
func _on_host_country_input_text_changed(new_text: String) -> void:
	league_pyramid_info[league_pyramid_index].Host_Country_Name = new_text;
	
# League N Repeatition Years SpinBox
func _on_every_n_years_input_value_changed(value: float) -> void:
	league_pyramid_info[league_pyramid_index].Every_N_Years = value;


func _on_start_month_input_item_selected(index: int) -> void:
	# First we store the month in date
	league_pyramid_info[league_pyramid_index].Start_Date.push_back()
