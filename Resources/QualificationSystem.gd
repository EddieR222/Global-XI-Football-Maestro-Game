class_name QualificationSystem extends Resource


@export_enum("INPUT", "SPECIFIC", "TOURNAMENT", "RANKING") var Qualification_Type: int;

""" Specific Specific Details """
@export var Specific_Team: int; #Team_ID

""" Tournament Specific Details """
@export var Winner: bool;
@export var Tour: int; # Tournament ID
@export var Stage_ID: int;

""" Ranking Specific Details """
@export var Ranking_System: int;
@export var Position_In_Ranking: int;
@export var Position_In_League: int = 0;
