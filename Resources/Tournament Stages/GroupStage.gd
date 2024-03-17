class_name GroupStage extends "res://Resources/Tournament Stages/TournamentStage.gd"

""" GroupStage Specific Options """
@export var Type: int = 2; #2 is for GroupStage
@export var Num_Matches_Played: int = 0;
@export var Num_Home_Matches: int = 0;
@export var Num_Away_Matches: int = 0;

@export var Points_For_Win: int = 3;
@export var Points_For_Draw: int = 1; 
@export var Points_For_Lose: int = 0;

@export var GroupTables: Dictionary = {};
@export var GroupSize: int;

""" Promotion and Relegation System """
## Promotion: The numbers here show which positions in all groups are considered winners
@export
var Winners: Array[int] = []; 

## Relegation: The numbers here show which positions in all groups are considered losers
@export
var Losers: Array[int] = [];

## Misc Output Teams.
## Other positions in all Groups that we would like to output.
var Miscs: Array[int] = [];
var Misc_Winner: Array[bool] = [];


""" Setter Functions """
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

## Set the Number of Groups. ONLY for when GroupStage is started
func set_number_of_groups(num: int) -> void:
	if not GroupTables.is_empty():
		return
	
	# We simply create the keys for the dictionary
	for key_val: int in range(1, num + 1):
		GroupTables[key_val] = [];
		
## Given an array of teams, create the group for this list. All groups MUST be of the same size
func set_group_stage(teams: Array[Team], group_num: int) -> void:
	# Validate Group Number
	if group_num not in GroupTables.keys():
		return
	# Validate Group Size
	if GroupSize > 0 and GroupSize != teams.size():
		return 
		
	# Now we set the league table for each group
	var group_table: Array[TeamLeagueStats] = [];
		
	# Create a new team league stats for each team
	for team: Team in teams:
		# Create TeamLeagueStats for each team
		var teamleaguestats = TeamLeagueStats.new();
		teamleaguestats.set_team(team.ID, team.Name);
		
		# Add it to group_table
		group_table.push_back(teamleaguestats);
		
	#Finally, sort group table by points and store in group_num
	group_table.sort_custom(sorting_function);
	GroupTables[group_num] = group_table
		

""" Getter Functions """

func get_group(num: int) -> Array[TeamLeagueStats]:
	if num not in GroupTables.keys():
		return [];
		
	return GroupTables[num];
	

""" Sort Groups by ... """
func sort_groups() -> void:
	# For all groups, sort them
	for group: Array[TeamLeagueStats] in GroupTables.values():
		group.sort_custom(sorting_function);
	

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
	
