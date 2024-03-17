class_name TeamLeagueStats extends Resource

@export var Team_ID: int
@export var Team_Name: String
@export var Games_Played: int;
@export var Wins: int;
@export var Draws: int;
@export var Losts: int;
@export var Goals_For: int;
@export var Goals_Against: int;
@export var Goals_Diff: int;
@export var Points: int;
@export var Form: Array[int];
@export var Yellow_Cards: int;
@export var Red_Cards: int;


@export var Points_For_Win: int = 3
@export var Points_For_Draw: int = 1
@export var Points_For_Lose: int = 0




func set_team(id: int, name: String) -> void:
	Team_ID = id; 
	Team_Name = name;

func set_point_system(win_points: int, lose_points: int, draw_points: int):
	Points_For_Win = win_points;
	Points_For_Lose = lose_points;
	Points_For_Draw = draw_points;

func add_game_result(result: String, goals_F: int, goals_A: int, yellow_cards:int, red_cards: int):
	# First we update the Games Played and Add Game Result to Form
	Games_Played += 1;
	if Form.size() == 5:
		Form.pop_front();
	
	if result == "W":
		Form.push_back(Points_For_Win);
		#Update Wins Number
		Wins += 1;
		#Update Points
		Points += Points_For_Win
	elif result == "L":
		Form.push_back(Points_For_Lose);
		#Update Lost Numbers
		Losts += 1;
		#Update Points Number
		Points += Points_For_Lose;
	else:
		Form.push_back(Points_For_Draw);
		#Update Draw Numbers
		Draws += 1;
		#Update Points
		Points += Points_For_Draw;
	# 
	
	#Finally, update Goals info and Card Info
	Yellow_Cards += yellow_cards;
	Red_Cards += red_cards
	
	Goals_For += goals_F;
	Goals_Against += goals_A;
	Goals_Diff = Goals_For - Goals_Against;
	

func _init():
	var league_stats = TeamLeagueStats.new();
	league_stats.Games_Played = 0;
	league_stats.Wins = 0;
	league_stats.Losts = 0;
	league_stats.Draws = 0;
	league_stats.Goals_Against = 0;
	league_stats.Goals_Diff = 0;
	league_stats.Goals_For = 0;
	league_stats.Yellow_Cards = 0;
	league_stats.Red_Cards = 0;
	
	league_stats.Points = 0;
	league_stats.Form = 0;
	
	league_stats.Points_For_Win = 3;
	league_stats.Points_For_Draw = 1;
	league_stats.Points_For_Lose = 0;
	


	
	




