class_name SingleKnockOutStage extends "res://Resources/Tournament Stages/TournamentStage.gd"

""" KnockOut Specific Options """
@export var Num_Matches: int;
@export var Potted: bool;



""" Promotion and Relegation System """
## Promotion: The numbers here show the winners of which rounds in the knockout rounds are considered winners
@export
var Winners: bool;#Default is the last round only, since this is normally the sole winner of the knockout tournament 

## Relegation: The numbers here show the winners of which rounds in the knockout rounds are considered losers
@export
var Losers: bool;

## Misc Output Teams.
## Additonal Rounds to get the winners or losers of
var Miscs: bool; # whether to onclude losers as winners

""" The Rounds of the Knockout tournament """
@export var Round: KnockOutRound;
