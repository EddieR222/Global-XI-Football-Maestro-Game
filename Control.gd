extends Control

@onready var item_list: ItemList = get_node("VBoxContainer/ItemList");


func _on_add_pressed():
	#Create empty territory to add to itemlist
	var new_terr: Territory = Territory.new();
	new_terr.Territory_Name = "Communication Works!!!";
	
	# Add to Itemlist
	var index: int = item_list.add_item(new_terr.Territory_Name, null, true);
	
	#Set Metadata
	item_list.set_item_metadata(index, new_terr);
	


func _on_item_list_item_selected(index: int) -> void:
	#First we get the item from item_list
	var terr = item_list.get_item_metadata(index);
	
	print(terr.Territory_Name);
	
