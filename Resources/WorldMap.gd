class_name WorldMap extends Resource

@export var Confederation_Dict: Dictionary;



func get_level_one_confedertion(region_id: int) -> Confederation:
	#Get current region 
	var current_region: Confederation = Confederation_Dict[region_id];
	
	# Loop until we reach level 1 confederaton
	while current_region.Level != 1:
		current_region = Confederation_Dict[current_region.Owner_ID];
	
	# Return confederation that is level 1
	return current_region
	
	
func get_children_confederation(region_id: int) -> Array[Confederation]:
	var children: Array[Confederation] = [];
	var current_region: Confederation = Confederation_Dict[0]
	for id in range(1, Confederation_Dict.size()):
		current_region = Confederation_Dict[id];
		if current_region.Owner_ID == region_id:
			children.push_back(current_region)
			
	return children
	
	

			








	

