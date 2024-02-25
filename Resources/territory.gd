class_name Territory
extends Resource


# Identifying Information
@export var Territory_ID: int;
@export var Territory_Name: String;
@export var CoTerritory_ID: int;
@export var CoTerritory_Name: String;
@export var Confederation_ID: int
@export var Confederation_Name: String;
@export var Code: String;
@export var Flag: Image;

# Country Information
@export var Population: float; # In Millions
@export var Area: float; #In Thousands
@export var GDP: float; # In Billions


# Name Database
@export var First_Names: PackedStringArray;
@export var Last_Names: PackedStringArray;


# Soccer Ratings (Domestic and International) 
@export var Rating: float;
@export var League_Elo: float;

@export var test: int
# Tournaments in Country	
@export var Tournaments: Dictionary

# Teams
@export var Teams: Dictionary

