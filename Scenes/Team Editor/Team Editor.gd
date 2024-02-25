extends Control


""" ItemList Details"""
var terr_index: int;
var terr_list: Dictionary
var team_index: int;
var team_list: Dictionary

""" Team Info """
var all_teams: Dictionary;

"""
The following Functions Handle the Saving and Loading of Files
"""

func _on_load_file_pressed():
	$FileDialog.visible = true
	
func _on_file_dialog_file_selected(path: String):
	var file_map : WorldMap = ResourceLoader.load(path) as WorldMap;
	
	var item_list: ItemList = get_node("VBoxContainer/Editor Bar/Country List");
	
	for confed: Confederation in file_map.Confederations.values():
		if confed.Level != 1:
			continue
		# Add Confed Item, its not selectable and Gray Background
		var confed_name = confed.Name;
		var index: int = item_list.add_item(confed_name, null, false);
		item_list.set_item_custom_bg_color(index, Color(0.486, 0.416, 0.4));
		
		for terr: Territory in confed.Territory_List.values():
			# Get Territory Name
			var terr_name = terr.Territory_Name;
			# Get Territory Flag or Icon
			var texture_normal
			var flag = terr.Flag;
			if flag != null:
				flag.decompress();
				texture_normal = ImageTexture.create_from_image(flag);
			else:
				var default_icon: CompressedTexture2D = load("res://Images/icon.svg");
				texture_normal = default_icon;
			# Add to item list
			var terr_index: int = item_list.add_item(terr_name, texture_normal, true);
			# Add to dictionary to keep track
			terr_list[terr_index] = terr;



"""

"""
func load_territory_teams(terr: Territory) -> void:
	# Get ItemList for Teams
	var item_list: ItemList = get_node("VBoxContainer/Editor Bar/VBoxContainer/Team List");
	
	#Clear itemlist
	item_list.clear();
	
	# Now add all teams in territory selected
	for team: Team in terr.Teams.values():
		# Get team name and logo
		var team_name = team.Name;
		var logo: Image = team.Logo;
		var texture_normal
		if logo != null:
			logo.decompress();
			texture_normal = ImageTexture.create_from_image(logo);
		else:
			var default_icon: CompressedTexture2D = load("res://Images/icon.svg");
			texture_normal = default_icon;
		item_list.add_item(team_name, texture_normal, true);

	#Set Team Dictionay locally
	team_list = terr.Teams;

"""
The function below are to change the index when the user selects a new territory or team
"""
func _on_country_list_item_selected(index: int) -> void:
	var selected_terr: Territory = terr_list[index];
	load_territory_teams(selected_terr);
	terr_index = index


func _on_team_list_item_selected(index: int) -> void:
	pass # Replace with function body.


"""
This function handles the automatic alphabetizational of teams (by Team Name) and handling Team IDs automatically
"""
func organize_team_ids() -> void:
	var entire_team_list: Array = [];
	var entire_team_dict: Dictionary = {};
	# First we need to iterate through all territories to get their teams
	for terr: Territory in terr_list.values():
		#Now we need to add teams array to entire_team_list
		entire_team_list.append_array(terr.Teams.values())
		
	#Now we sort through the teams to get the in alphabetical order
	entire_team_list.sort_custom(func(a: Team, b: Team): a.Name < b.Name);
	
	#Finally we turn it into a dictionary, starting at ID 1
	var index = 1;
	for team: Team in entire_team_list:
		team.ID = index
		entire_team_dict[index] = team
		
	#Assign Global Variable all_teams
	all_teams = entire_team_dict;	



"""
The functions below are responcible for adding and deleting teams from Team List
"""
func _on_add_team_pressed():
	# Create new Team Object
	var team: Team = Team.new();
	
	#Get currently selected Territory
	var terr: Territory = terr_list[terr_index];
	
	#Store Default Information for a new Team in this territory
	team.Name = "Team Name"
	team.Territory_Name = terr.Territory_Name;
	team.Territory_ID = terr.Territory_ID;
	team.ID = all_teams.size();
	all_teams[team.ID] = team;
	
	#Alphabetize Team List
	organize_team_ids();
	
	#Add it to itemlist
	var item_list: ItemList = get_node("VBoxContainer/Editor Bar/VBoxContainer/Team List");
	var default_icon: CompressedTexture2D = load("res://Images/icon.svg");
	var index = item_list.add_item(team.Name, default_icon, true);
	team_list[index] = team;
	
func _on_delete_team_pressed():
	$ConfirmationDialog.visible = true

func _on_confirmation_dialog_confirmed():
	pass
