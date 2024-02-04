extends GraphNode


var selected_index: int


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_add_territory_pressed():
	var texture: CompressedTexture2D = load("res://Images/icon.svg");
	var index: int = $HBoxContainer/ItemList.add_item("Territory", texture, true);


func _on_delete_territory_pressed():
	$ConfirmationDialog.visible = 1;


func _on_confirmation_dialog_confirmed() -> void:
	$HBoxContainer/ItemList.remove_item(selected_index)
	


func _on_item_list_item_selected(index: int) -> void:
	selected_index = index



