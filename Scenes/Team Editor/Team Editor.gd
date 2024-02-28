extends Control


""" ItemList Details"""
var terr_index: int = -1
var terr_list: Dictionary
var team_index: int = -1
var team_list: Dictionary

""" Team Info """
var all_teams: Dictionary;

""" File Name """
var FileName : String; 

"""
The following Functions Handle the Saving and Loading of Files
"""

func _on_load_file_pressed():
	get_node("World Map File Dialog").visible = true
	
func _on_file_dialog_file_selected(path: String):
	# Load the data saved in Disk
	var file_map : WorldMap = ResourceLoader.load(path) as WorldMap;
	
	#Change the FileName to display what the name of file was, so user can automatically
	#save changes easily
	FileName = path.get_file().get_basename();
	var file_name_edit: LineEdit = get_node("VBoxContainer/Title Bar/LineEdit");
	file_name_edit.text = FileName
	
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
These functions deal with the ItemList for Teams
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
	# Save current teams to country info
	if terr_index != -1:
		var previous_terr: Territory = terr_list[terr_index];
		previous_terr.Teams = team_list
	
	
	# Get Selected Territory and display them to Item List/Save them locally
	var selected_terr: Territory = terr_list[index];
	load_territory_teams(selected_terr);
	terr_index = index
	
func _on_team_list_item_selected(index: int) -> void:
	#We need to display the territory selected
	team_index = index
	
	#Call Group to display territory
	get_tree().call_group("Team_Info", "team_selected", team_list[team_index])
	
	# Alphabetize all team ids;
	organize_team_ids();
	organize_country_teams(terr_index);
	
	# We also need to relfect any logo, team_name, or ID changes to previously selected teams
	reflect_team_changes();

func reflect_team_changes() -> void:
	# First get the current list of teams and clear the itemlist
	var item_list: ItemList = get_node("VBoxContainer/Editor Bar/VBoxContainer/Team List");
	item_list.clear();
	# Now add all teams in territory selected
	for team: Team in team_list.values():
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
	
func delete_and_organize() -> void:
	# First we remove the team selected from local dictionary
	team_list.erase(team_index);
	
	# Now we get all teams and alphabetize them
	var entire_team_arr = team_list.values();
	entire_team_arr.sort_custom(func(a, b): return a.Name < b.Name);
	
	# Now we recreate the Team List
	var entire_team_dict: Dictionary = {};
	var index: int = 0;
	for team: Team in entire_team_arr:
		entire_team_dict[index] = team;
		index += 1;
		
	team_list = entire_team_dict; 
			
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
	entire_team_list.sort_custom(func(a: Team, b: Team): return a.Name < b.Name);
	
	#Finally we turn it into a dictionary, starting at ID 1
	var index = 1;
	for team: Team in entire_team_list:
		team.ID = index
		entire_team_dict[index] = team
		index += 1;
		
	#Assign Global Variable all_teams
	all_teams = entire_team_dict;
	
func organize_country_teams(index: int) -> void:
	# Get Territory 
	var selected_terr: Territory = terr_list[index];
	
	# Now we get all teams and alphabetize them
	var entire_team_arr = team_list.values();
	entire_team_arr.sort_custom(func(a, b): return a.Name < b.Name);
	
	# Now we recreate the Team List
	var entire_team_dict: Dictionary = {};
	var new_index: int = 0;
	for team: Team in entire_team_arr:
		entire_team_dict[new_index] = team;
		new_index += 1;
		
	team_list = entire_team_dict; 

"""
The functions below are responcible for adding and deleting teams from Team List
"""
func _on_add_team_pressed() -> void:
	# If user hasn't selected a territory to save this new team in, return early
	if terr_index == -1:
		return
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
	
	##Alphabetize Team List
	organize_country_teams(terr_index);
	organize_team_ids();
	
	#Add it to itemlist
	var item_list: ItemList = get_node("VBoxContainer/Editor Bar/VBoxContainer/Team List");
	var default_icon: CompressedTexture2D = load("res://Images/icon.svg");
	var index = item_list.add_item(team.Name, default_icon, true);
	
	#Add it to local dictionary to keep track of it
	team_list[index] = team;
	
func _on_delete_team_pressed():
	get_node("Delete Team Confirmation").visible = true

func _on_confirmation_dialog_confirmed():
	# No team or territory selected means we won't delete any team, return early
	if team_index == -1 or terr_index == -1:
		return
		
	delete_and_organize();
	
	organize_country_teams(terr_index);
	organize_team_ids();
	
	reflect_team_changes();

""" Functions for Logo, Team Name, and Team ID"""
func _on_logo_pressed():
	$"Logo File Dialog".visible = true;

func _on_logo_file_dialog_file_selected(path):
	# Load Image of Team Logo
	var logo: Image = Image.load_from_file(path);
	logo.resize(150, 150, 2);
	var logo_texture: ImageTexture = ImageTexture.create_from_image(logo);
	
	# Change Texture of Texture Button to reflect change
	$"VBoxContainer/Editor Bar/Middle/HBoxContainer/Logo".texture_normal = logo_texture
	
	# Save Image into Territory Class
	logo.compress(Image.COMPRESS_BPTC);
	team_list[team_index].Logo = logo;
	
	# Now we want to reflect team changes
	reflect_team_changes();

func _on_team_name_text_changed(new_text: String) -> void:
	# Save New Team Name
	team_list[team_index].Name = new_text

	reflect_team_changes();
	
