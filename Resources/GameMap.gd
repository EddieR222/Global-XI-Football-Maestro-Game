class_name GameMap extends Resource
## The File that contains all information for the game
##
## This Class contains all the information for the game including territories, confederations, teams, tournaments, etc.
## It also contains a lot of useful functions for parsing and working with this data

@export_category("World Map")
## The Dictionary that contains all Confederations. 
@export 
var Confederations: Array[Confederation] = [];
## The Dictionary that contains all Territories. 
@export 
var Territories: Array[Territory] = [];

@export_category("Team Details")
## The Dictionary that contains all Teams. 
@export
var Teams: Array[Team] = [];

## The Dictionary that contains all Stadiums. 
@export
var Stadiums: Array[Stadium] = [];

@export_category("Tournament Details")
## The Dictionary that contains all Tournaments.
@export
var Tournaments: Array[Tournament] = [];


""" Getter Functions """
## Function to get confed by inputted id. Returns null if id is NOT valid
func get_confed_by_id(id: int) -> Confederation:
	# Check to see if id is valid, if not valid then return null
	if id < 0 or id >= Confederations.size():
		return null
	
	# If valid, then return corresponding confederation
	return Confederations[id];

## Function to get territory by inputted id. Returns null if id is NOT valid
func get_territory_by_id(id: int) -> Territory:
	# Check to see if id is valid, if not valid then return null
	if id < 0 or id >= Territories.size():
		return null
	
	# If valid, then return corresponding territory
	return Territories[id];

## Function to get team by inputted id. Returns null if id is NOT valid
func get_team_by_id(id: int) -> Team:
	# Check to see if id is valid, if not valid then return null
	if id < 0 or id >= Teams.size():
		return null
	
	# If valid, then return corresponding team
	return Teams[id];

## Function to get territory by inputted id. Returns null if id is NOT valid
func get_tournament_by_id(id: int) -> Tournament:
	# Check to see if id is valid, if not valid then return null
	if id < 0 or id >= Tournaments.size():
		return null
	
	# If valid, then return corresponding territory
	return Tournaments[id];
	
	


""" Sorting and ID managment """
## This functions sorts the confederations in alphabetical order by name. 
## Also changes IDs based on new alphabetical order
func sort_confederations() -> void:
	# Sort the array based on Name (Alphabetical Order)
	Confederations.sort_custom(func(a: Confederation, b: Confederation): return a.Name < b.Name);
	
	# Now update the ID of each Territory, based on index in Array
	var index = 0;
	for confed: Confederation in Confederations:
		confed.ID = index;
		index += 1;
	
## This functions sorts the territories in alphabetical order by name. 
## Also changes IDs based on new alphabetical order
func sort_territories() -> void:
	# Sort the array based on Name (Alphabetical Order)
	Territories.sort_custom(func(a: Territory, b: Territory): return a.Territory_Name < b.Territory_Name);
	
	# Now update the ID of each Territory, based on index in Array
	var index = 0;
	for terr: Territory in Territories:
		terr.Territory_ID = index;
		index += 1;

## This functions sorts the teams in alphabetical order by name. 
## Also changes IDs based on new alphabetical order
func sort_teams() -> void:
	# Sort the array based on Name (Alphabetical Order)
	Teams.sort_custom(func(a: Team, b: Team): return a.Name < b.Name);
	
	# Now update the ID of each Territory, based on index in Array
	var index = 0;
	for team: Team in Teams:
		team.ID = index;
		index += 1;

## This functions sorts the tournaments in alphabetical order by name. 
## Also changes IDs based on new alphabetical order
func sort_tournaments() -> void:
	# Sort the array based on Name (Alphabetical Order)
	Tournaments.sort_custom(func(a: Tournament, b: Tournament): return a.Name < b.Name);
	
	# Now update the ID of each Territory, based on index in Array
	var index = 0;
	for tour: Tournament in Tournaments:
		tour.ID = index;
		index += 1;
		
		
		
""" Remove or Erase By ID """
