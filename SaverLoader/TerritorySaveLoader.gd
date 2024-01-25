class_name TerritorySaveLoader extends Node


@export var Num_Country: int;
@export var FileName: String;
@export var Territory_List: TerritoryList



func save_territories(): 
	ResourceSaver.save(Territory_List, "user://territories.tres")
	
	
func load_territories():
	var Territory_List: TerritoryList = load("user://territories.tres") as TerritoryList;
	
	
	
	
	

