class_name TerritorySaveLoader extends Node


@export var Num_Country: int;
@export var FileName: String;
@export var Territory_List: TerritoryList
@export var item_dict: Dictionary;
@export var selected_index: int = -1;



func alphabetize_country_list():
	pass
	


func _on_load_file_pressed():
	$"../FileDialog".visible = 1;

	
		

func _on_save_file_pressed():
	var territory_list: TerritoryList = TerritoryList.new();
	var saved_territories: Array[Territory] = [];
	
	for territory: Territory in item_dict.values():
		saved_territories.push_back(territory);
	
	territory_list.list = saved_territories
	
	ResourceSaver.save(territory_list, "user://default.tres");
	
	
# This function will run when the player presses the "Add Country" Button
func _on_add_territory_pressed():
	# Add a blank Territory Item to ItemList
	var texture = load("res://Images/icon.svg");
	var index: int = $"../MarginContainer/HBoxContainer/VBoxContainer/ItemList".add_item("Territory", texture, true);
	
	# Add blank Territory Item List to List Dictionary
	var t: Territory = Territory.new();
	item_dict[index] = t;
	
	

# This function will run when the player selects a territory in the ItemList
func _on_item_list_item_selected(index):
	#Get Selected Territory from ItemList Dictionary
	var t: Territory = item_dict[index];
	
 	# Call all input UI and change them to selected Territory information
	get_tree().call_group("T_Info", "territory_selected", t);
	
	
	# Set current selected index to given index
	selected_index = index
	
	
func _on_line_edit_text_changed(new_text):
	# Set new_text for ItemList
	$"../MarginContainer/HBoxContainer/VBoxContainer/ItemList".set_item_text(selected_index, new_text);
	
	#Update info inside of dictionary
	item_dict[selected_index].Territory_Name = new_text;
	


func _on_t_id_value_changed(value):
	item_dict[selected_index].Territory_ID = value;


func _on_co_t_id_value_changed(value):
	item_dict[selected_index].CoTerritory_ID = value;
	
	
func _on_co_t_name_text_changed(new_text):
	item_dict[selected_index].CoTerritory_Name = new_text;


func _on_code_name_text_text_changed(new_text):
	item_dict[selected_index].Code = new_text.to_upper();
	

func _on_pop_val_value_changed(value):
	item_dict[selected_index].Population = value;


func _on_area_val_value_changed(value):
	item_dict[selected_index].Area = value;


func _on_gdp_val_value_changed(value):
	item_dict[selected_index].GDP = value;


func _on_first_name_list_text_changed():
	var name_list: PackedStringArray = $"../MarginContainer/HBoxContainer/VBoxContainer2/GridContainer/First Name List".text.split(",", false, 0);
	name_list.sort();
	var saved_names: PackedStringArray = [];
	for name in name_list:
		saved_names.push_back(name.strip_edges(true, true));
	item_dict[selected_index].First_Names = saved_names 


func _on_last_names_list_text_changed():
	var name_list: PackedStringArray = $"../MarginContainer/HBoxContainer/VBoxContainer2/GridContainer/Last Names List".text.split(",", false, 0);
	name_list.sort();
	var saved_names: PackedStringArray= []
	for name in name_list:
		saved_names.push_back(name.strip_edges(true, true));
	item_dict[selected_index].Last_Names = saved_names


func _on_rating_value_value_changed(value):
	item_dict[selected_index].Rating = value;


func _on_league_rating_val_value_changed(value):
	item_dict[selected_index].Area = value;




func _on_file_dialog_file_selected(path):
	# Load the List of Territories from the file in user data
	Territory_List = load(path) as TerritoryList;
	$"../MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/GridContainer/MarginContainer6/LineEdit".text = path
	
	# Clear Item Dictionary as we want to just load the new ones in
	item_dict = {};
	
	# Clear the ItemList of all items 
	$"../MarginContainer/HBoxContainer/VBoxContainer/ItemList".clear();
	
	#Load all territories into itemlist and save their positions inside item dictionary
	for territory in Territory_List.list:
		# Load Flag of territory
		var territory_flag = load("res://Images/icon.svg");
		
		# Add Territory into Itemlist
		var index = $"../MarginContainer/HBoxContainer/VBoxContainer/ItemList".add_item(territory.Territory_Name, territory_flag, true );
		
		item_dict[index] = territory;
