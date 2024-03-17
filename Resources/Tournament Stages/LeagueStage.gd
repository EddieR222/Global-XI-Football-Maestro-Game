class_name LeagueStage extends "res://Resources/Tournament Stages/TournamentStage.gd"

""" League Specific Options """
@export var Type: int = 1;
@export var Num_Matches_Played: int;
@export var Num_Home_Matches: int;
@export var Num_Away_Matches: int; 

@export var Points_For_Win: int = 3;
@export var Points_For_Draw: int = 1; 
@export var Points_For_Lose: int = 0;

@export var LeagueTable: Array[TeamLeagueStats] = [];


""" Promotion and Relegation System """
## Promotion: The numbers here show which positions in the league table are considered winners
@export
var Winners: Array[int] = []; 

## Relegation: The numbers here show which positions in the league table are considered losers
@export
var Losers: Array[int] = [];

## Misc Output Teams
var Miscs: Array[int] = [];
var Misc_Winner: Array[int] = [];

""" Init """
#func _init():
	#pass


""" Setter Functions """
## Set the Number of Matches played, matches played at home, and matches played away
func set_num_matches(num: int) -> void:
	# Set Num Matches Played as given number
	Num_Matches_Played = num;
	
	# Set the number of home matches as half (rounded up)
	Num_Home_Matches = ceili(float(num) / 2.0);
	
	# Set the number of away matches as the remaining matches
	Num_Away_Matches = Num_Matches_Played - Num_Home_Matches;

## Set the Points Earned Per Win
func set_win_points(points: int) -> void:
	Points_For_Win = points;

## Set the Points Earned Per Draw
func set_draw_points(points: int) -> void:
	Points_For_Draw = points;
	
## Set the Points Earned Per Lose
func set_lose_points(point:int) -> void:
	Points_For_Lose = point;

func set_league_table(teams: Array[int], game_map: GameMap) -> void:
	for team_id: int in teams:
		# Get Team
		var team: Team = game_map.get_team_by_id(team_id);
		
		# Create Team League Stats
		var team_league_stats: TeamLeagueStats = TeamLeagueStats.new();
		
		# Store into array
		LeagueTable.push_back(team_league_stats);

	# Sort LeagueTable
	sort_league_table();

""" Sorting Info """
func sort_league_table() -> void:
	LeagueTable.sort_custom(sorting_function);

func sorting_function(a: TeamLeagueStats, b: TeamLeagueStats) -> bool:
	# First we sort by Points, if equal then we sort by the next criteria which is goal difference
	if a.Points != b.Points:
		return a.Points > b.Points; # > for descending
		
	# Sort by Goal Difference, if this is also equal then we sort by third criteria, goal scored
	if a.Goals_Diff != b.Goals_Diff:
		return a.Goals_Diff > b.Goals_Diff;  
		
	# Sort by Goals Scored, if equal then result to yellow cards
	if a.Goals_For != b.Goals_For:
		return a.Goals_For > b.Goals_For;
		
	# Sort by Yellow Cards, if still equal then rank by recent form
	if a.Yellow_Cards != b.Yellow_Cards: 
		return a.Yellow_Cards < b.Yellow_Cards;
		
	# Sort by recent form, if still equal then choose random
	var a_form_sum: int = 0;
	for points: int in a.Form:
		a_form_sum += points;
		
	var b_form_sum: int = 0;
	for points: int in b.Form:
		b_form_sum += points
		
	if a_form_sum != b_form_sum:
		return a_form_sum > b_form_sum;
		
	# Finally, if its still a tie, just randomly choose the winner
	var random_bool: Array = [true, false];
	return random_bool.pick_random();
	

""" Updating League Table """

