class_name Tournament extends Resource


@export var Logo: Image;
@export var Name: String
@export var ID: int
@export var Importance: int
@export var Original_Teams: Array
@export var Player_Team: int; 


@export var Host_Country_Name: String
@export var Host_Country_ID: int

@export var Every_N_Years: float;
@export var Start_Date: Array = []
@export var End_Date: Array = []

""" Qualification: How do teams qualify? """
@export var Num_Teams: int;
@export var Qualifying_Tournaments: Array[QualificationSystem];


""" Disqualification: How do teams disqualify? (relegation, losers, etc) """
@export var Disqualification: Array[QualificationSystem];

""" Tournament Stages """
@export var TournamentStages: Array[TournamentStage]

