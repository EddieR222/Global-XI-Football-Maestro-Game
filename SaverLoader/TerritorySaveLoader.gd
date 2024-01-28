class_name TerritorySaveLoader extends Node


@export var Num_Country: int;
@export var FileName: String;
@export var Territory_List: TerritoryList
@export var item_dict: Dictionary;
@export var selected_index: int = -1;



func alphabetize_country_list():
	
	# Sort ItemList by Alphabetical Order
	$"../MarginContainer/HBoxContainer/VBoxContainer/ItemList".sort_items_by_text();
	
	# Now Reorganize Dictionary to Reflect new index order after alphabetizing
	var size_items: int = $"../MarginContainer/HBoxContainer/VBoxContainer/ItemList".item_count
	var new_dict: Dictionary = {};
	
	for index: int in range(0, size_items):
		var territory: String = $"../MarginContainer/HBoxContainer/VBoxContainer/ItemList".get_item_text(index);
		print(territory)
		
		for t: Territory in item_dict.values():
			if t.Territory_Name == territory:
				new_dict[index] = t;
	
	item_dict = new_dict
	for t: Territory in item_dict.values():
		print(t.Territory_Name);	
		
		
		
	
	
	
	


func _on_load_file_pressed():
	$"../FileDialog".visible = 1;

	
		

func _on_save_file_pressed():
	var territory_list: TerritoryList = TerritoryList.new();
	var saved_territories: Array[Territory] = [];
	
	for territory: Territory in item_dict.values():
		saved_territories.push_back(territory);
	
	territory_list.list = saved_territories
	
	var file_name: String = $"../MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/GridContainer/MarginContainer6/LineEdit".text;
	ResourceSaver.save(territory_list, "user://{filename}.tres".format({"filename": file_name}));
	
	
# This function will run when the player presses the "Add Country" Button
func _on_add_territory_pressed():
	# Add a blank Territory Item to ItemList
	var texture: CompressedTexture2D = load("res://Images/icon.svg");
	var index: int = $"../MarginContainer/HBoxContainer/VBoxContainer/ItemList".add_item("Territory", texture, true);
	
	# Add blank Territory Item List to List Dictionary
	var t: Territory = Territory.new();
	t.Territory_Name = "Territory"
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
	
	#Update Flag FilePath to reflect name change
	#var old_path: String = item_dict[selected_index].Territory_Name + ".png";
	#var new_path: String = new_text + ".png";
	
	#var dir: DirAccess = DirAccess.open("res://Images/Territory Flags/");
	#var err: Error = dir.rename(old_path, new_path);
	
	#if dir.file_exists(new_path):		
		#var new_filename = "res://Images/Territory Flags/" + new_path;
		#var new_flag: CompressedTexture2D = load(new_filename);
		#$"../MarginContainer/HBoxContainer/VBoxContainer/ItemList".set_item_icon(selected_index, new_flag);
	
	
	item_dict[selected_index].Territory_Name = new_text;
	
	#alphabetize_country_list();
	
	


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
	$"../MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/GridContainer/MarginContainer6/LineEdit".text = path.get_file().replace(".tres", "");
	
	# Clear Item Dictionary as we want to just load the new ones in
	item_dict = {};
	
	# Clear the ItemList of all items 
	$"../MarginContainer/HBoxContainer/VBoxContainer/ItemList".clear();
	
	#Load all territories into itemlist and save their positions inside item dictionary
	for territory in Territory_List.list:
		# Load Flag of territory
		var flag = territory.Flag;
		flag.decompress();
		var territory_flag = ImageTexture.create_from_image(flag)
		
		# Add Territory into Itemlist
		var index = $"../MarginContainer/HBoxContainer/VBoxContainer/ItemList".add_item(territory.Territory_Name, territory_flag, true );
		
		item_dict[index] = territory;
		
	


func _on_texture_button_pressed():
	$"../Flag Input".visible = 1;


func _on_flag_input_file_selected(path):
	# Load Image of Territory Flag
	var flag: Image = Image.load_from_file(path);
	flag.resize(120, 80, 2);
	
	
	var flag_texture: ImageTexture = ImageTexture.create_from_image(flag);
	
	## Now we create new filepath
	#var new_filepath: String = "res://Images/Territory Flags/" + item_dict[selected_index].Territory_Name + ".png"
	#
	#flag.save_png(new_filepath);
	#item_dict[selected_index].Flag = compressed_flag;
	
	$"../MarginContainer/HBoxContainer/VBoxContainer/ItemList".set_item_icon(selected_index, flag_texture);
	$"../MarginContainer/HBoxContainer/VBoxContainer2/HBoxContainer/TextureButton".texture_normal = flag_texture
	
	flag.compress(Image.COMPRESS_BPTC);
	item_dict[selected_index].Flag = flag;
	
	
	
	
	
	


func _on_delete_territory_pressed():
	$"../MarginContainer/HBoxContainer/VBoxContainer/ItemList".remove_item(selected_index)
	
	item_dict.erase(selected_index);
	
	alphabetize_country_list();
	
	selected_index = 0;
	
	
