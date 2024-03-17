class_name KnockOutStage extends "res://Resources/Tournament Stages/TournamentStage.gd"


""" KnockOut Specific Options """
@export var Num_Matches_Each_Stage: int;
@export var Final_Num_Matches: int;
@export var Potted: int;



""" Promotion and Relegation System """
## Promotion: The numbers here show the winners of which rounds in the knockout rounds are considered winners
@export
var Winners: Array[int] = []; #Default is the last round only, since this is normally the sole winner of the knockout tournament 

## Relegation: The numbers here show the winners of which rounds in the knockout rounds are considered losers
@export
var Losers: Array[int] = [];

## Misc Output Teams.
## Additonal Rounds to get the winners or losers of
var Miscs: Array[int] = [];
var Misc_Winner: Array[bool] = [];

""" The Rounds of the Knockout tournament """
@export var Rounds: Array[]
