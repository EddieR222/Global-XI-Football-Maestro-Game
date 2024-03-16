class_name TournamentStage extends Resource

""" Identifying Info """
@export var Name: String
@export_enum("LEAGUE:0", "GROUP_STAGE:1", "KNOCKOUT:2", "SINGLE_KNOCKOUT:3") var Stage_Type: int;
@export var Stage_ID: int;
@export var Start_Date: Array;
@export var End_Date: Array;
#@export var Participating_Teams: Array;

""" Info For Graph """
@export var Next_Stages: Array[int]
@export var Previous_Stages: Array[int]





""" KnockOut Specific Options """

@export var Num_Matches_Each_Stage: int;
@export var Final_Num_Matches: int;

""" Single KnockOut and Knockout Specific Options """
@export var Allow_Same_League: bool;

""" GroupStage Specific Options """
@export var Groups: Array;



""" Getter Functions """
func get_stage_id() -> int:
	return Stage_ID
	
func get_stage_name() -> String:
	return Name;
	
	
	
	
	
	
#func set_num_matches_played(num: int) -> void:
	#Num_Matches_Played = num;
	#Num_Home_Matches = num / 2;
	#Num_Away_Matches = Num_Matches_Played - Num_Home_Matches;
	#return
