class_name Team extends Resource


""" Identifying Information """
@export var Name: String;
@export var Display_Name: String;
@export var Nick_Name: String
@export var Logo: Image
@export var ID: int;
@export var Name_Code: String;

""" Regional Information """
@export var Territory_Name: String;
@export var Territory_ID: int;
@export var City: String;

""" Team Info """
@export var Rating: int;
@export var League_Name: String;
@export var League_ID: int;
@export var Stadium_ID: int;
@export var Rivals_Name: String;
@export var Rivals_ID: String;


 
""" Club History """
@export var Trophies: Array
@export var League_History: Array


""" Player and Manager Info """
@export var Manager_Name: String;
@export var Manager_ID: int; 
@export var Players: Array[int]
