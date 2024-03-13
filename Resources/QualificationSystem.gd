class_name QualificationSystem extends Resource


@export_enum("INPUT:0", "SPECIFIC:1", "TOURNAMENT:2", "RANKING:3") var Qualification_Type: int;

""" Input Specific Details """
@export var Num_Teams_Accept: int = 0;

""" Specific Specific Details """
@export var Specific_Team: Team;

""" Tournament Specific Details """
@export var Winner: bool;
@export var Tour: Tournament;
@export var Stage_ID: int;

""" Ranking Specific Details """
@export var Ranking_System: int;
@export var Position_In_Ranking: int;
@export var Position_In_League: int = 0;
