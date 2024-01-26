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

# Country Information
@export var Population: int;
@export var Area: int;
@export var GDP: int;


# Name Database
@export var First_Names: PackedStringArray;
@export var Last_Names: PackedStringArray;


# Soccer Ratings (Domestic and International) 
@export var Rating: int;
@export var League_Elo: float;


	

