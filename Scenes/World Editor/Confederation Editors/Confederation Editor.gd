extends GraphNode


var selected_index: int
var territory_itemlist: Dictionary


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func get_selected_territory() -> Territory:
	var selected_territory: Territory = territory_itemlist[selected_index];
	return selected_territory;
	
func set_selected_territory(t: Territory) -> void:
	territory_itemlist[selected_index] = t;
	
func get_territory_dict() -> Dictionary:
	return territory_itemlist;

func _on_add_territory_pressed():
	# Add a blank territory item to ItemList
	var texture: CompressedTexture2D = load("res://Images/icon.svg");
	var index: int = $HBoxContainer/ItemList.add_item("Territory", texture, true);
	
	# For the item in the ItemList, we add a territory to the territory dictionary
	var default_territory: Territory = Territory.new();
	default_territory.Territory_Name = "Territory"
	territory_itemlist[index] = default_territory;


func _on_delete_territory_pressed():
	$ConfirmationDialog.visible = 1;


func _on_confirmation_dialog_confirmed() -> void:
	
	# FIrst we delete the territory from territory dictionary
	territory_itemlist.erase(selected_index);
	
	# Now we remove it from territory itemlist
	$HBoxContainer/ItemList.remove_item(selected_index);
	
	


func _on_item_list_item_selected(index: int) -> void:
	selected_index = index
	




