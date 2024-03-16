class_name Confederation extends Resource

@export var Name: String;
@export var ID: int;
@export var Level: int;
@export var Territory_List: Array[int]
@export var Owner_ID: int;
@export var Children_ID: Array[int];

""" Tournament Information """
@export var Confed_Tournaments: Array[int]
@export var Confed_Leagues: Array[int]
@export var Super_Cup: int = -1
@export var Cup: int = -1

""" Rankings or CoEfficients """
@export var National_Teams_Rankings: Array[int] #int = team_id
@export var National_League_Rankings: Array[int] #int = tournament_id
@export var Club_Teams_Rankings: Array[int] # int = team_id


""" Functions """
## Adds a new Territory to the list
func add_territory(id: int) -> void:
	# Id of territory should be positive
	if id < 0:
		return 
		
	# Ensure no duplicates
	if id in Territory_List:
		return
		
	# Add the id to Territory List
	Territory_List.push_back(id)
	
func delete_territory(id: int) -> void:
	# Id of territory should be positive
	if id < 0:
		return 
		
	# If id in List, remove. If not in list, do nothing
	Territory_List.erase(id)

## Update the old territory id to the new one
func update_territory_id(old_id: int, new_id: int) -> void:
	# Get Index to Change
	var index_to_change: int = Territory_List.find(old_id);
	
	# If Old_ID is present, swap it for new one
	if index_to_change != -1: #Not -1, then we found it
		Territory_List[index_to_change] = new_id;
