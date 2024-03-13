class_name Confederation extends Resource

@export var Name: String;
@export var ID: int;
@export var Level: int;
@export var Territory_List: Dictionary;
@export var Owner_ID: int;
@export var Children_ID: Array[int];

""" Tournament Information """
@export var Confed_Tournaments: Dictionary;
@export var Confed_Leagues: Dictionary;
@export var Super_Cup: int = -1
@export var Cup: int = -1

""" Rankings or CoEfficients """
@export var National_Teams_Rankings: Dictionary
@export var National_League_Rankings: Dictionary
@export var Club_Teams_Rankings: Dictionary

