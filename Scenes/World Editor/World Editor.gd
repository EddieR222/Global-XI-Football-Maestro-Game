extends Control


const CONFED_NODE : String = "res://Scenes/World Editor/Confederation Editors/Confederation Editor.tscn";
const TERRITORY_NODE : String = "res://Scenes/World Editor/Territory Editors/Territory Editor.tscn";


@export var Filename: String = ""


"""
Preload Nodes that we will instantiate later 
"""
@onready var confed_node: PackedScene = preload(CONFED_NODE);
@onready var terr_node: PackedScene = preload(TERRITORY_NODE);


"""
Functions below are responsible for saving and loading the WorldMap to user data. 
"""
func _on_save_file_pressed():
	# Init WorldMap Variable
	var save_map: WorldMap = WorldMap.new();
	
	# Get current world map and covert it into Resource version to save
	var world_map: Graph = $"VBoxContainer/Confed Edit".world_map
	save_map.save_confederations(world_map.graph_nodes);
	
	# Finally, save it to file
	ResourceSaver.save(save_map, "user://{filename}.res".format({"filename": Filename}));
	
func _on_line_edit_text_changed(new_text: String):
	Filename = new_text;

func _on_load_file_pressed():
	$FileDialog.visible = true;

func _on_file_dialog_file_selected(path):
	# First we need to delete all nodes on screen
	#Get the Graph Edit Node
	var graph_edit: GraphEdit = get_node("VBoxContainer/Confed Edit");
	for node: GraphNode in graph_edit.world_map.graph_nodes.values():
		node.queue_free();
		
	#graph_edit.world_map.clear();
	
	#Load the World Map from Disk
	var file_map : WorldMap = ResourceLoader.load(path) as WorldMap;

	# Start Graph Resource
	var world_map: Graph = Graph.new() 
	
	
	# Iter through the confederations
	var starting_x_positions = {
		1: -5000,
		2: -10000,
		3: -15000,
		4: -20000,
		5: -25000,
		6: -30000,
		7: -35000,
		8: -40000,
		9: -45000
	};
	for confed: Confederation in file_map.Confederations.values():
		var pos: Vector2;
		var world_confed_node: GraphNode
		# Establish Special World Node
		if confed.Name == "World":
			#Establish World Node
			world_confed_node = graph_edit.establish_world_node();
			world_confed_node.set_confed(confed);
			world_map.organize_specific_territories(world_confed_node);
			world_map.graph_nodes[0] = world_confed_node;
			
			#Establish Territory Edit
			var terr_edit_node: GraphNode = terr_node.instantiate();
			graph_edit.add_child(terr_edit_node);
			terr_edit_node.visible = 0;
			
			# Now we connect the territory edit node to the correct signals here
			graph_edit.connect_signals_from_territory_node(terr_edit_node);
			
			#Finally we add these nodes to the nodes tracker to be able to manpulate them later
			world_map.graph_nodes[1] = terr_edit_node;
			continue

		match confed.Level:
			0:
				pos = Vector2(0,0);
			1:
				pos = Vector2(starting_x_positions[1], 1 * 600)
				starting_x_positions[1] += 1200
			2:
				pos = Vector2(starting_x_positions[2], 2 * 600)
				starting_x_positions[2] += 1200
			3:
				pos = Vector2(starting_x_positions[3], 3 * 600)
				starting_x_positions[3] += 1200
			4:
				pos = Vector2(starting_x_positions[4], 4 * 600)
				starting_x_positions[4] += 1200
			5:
				pos = Vector2(starting_x_positions[5], 5 * 600)
				starting_x_positions[5] += 1200
			6:
				pos = Vector2(starting_x_positions[6], 6 * 600)
				starting_x_positions[6] += 1200
			7:
				pos = Vector2(starting_x_positions[7], 7 * 600)
				starting_x_positions[7] += 1200
			8:
				pos = Vector2(starting_x_positions[8], 8 * 600)
				starting_x_positions[8] += 1200
			9:
				pos = Vector2(starting_x_positions[9], 9 * 600)
				starting_x_positions[9] += 1200
		
		# For Non-World Nodes we do the normal things
		
		#Instantiate and add to scene tree
		var new_node: GraphNode = confed_node.instantiate(); 
		graph_edit.add_child(new_node);
		#Enable Slots for Confed Node
		graph_edit.enable_slots(new_node)
		#Connect Needed Signals
		graph_edit.connect_signals_from_confed_node(new_node)
		# Set appropiate Positions
		new_node.position_offset = pos;
		# Set the new confed and display Name, Level, And Territories
		new_node.set_confed(confed)
		#Add it to graph_nodes to keep track of it
		world_map.graph_nodes[world_map.graph_nodes.size()] = new_node
		
	redraw_saved_connections(world_map, graph_edit);
	world_map.organize_all_territories();
	graph_edit.world_map = world_map;
	graph_edit.arrange_nodes();
	print("Done");
	
func redraw_saved_connections(graph: Graph, graph_edit: GraphEdit) -> void:
	# We iter through all trees and redraw connections
	for node: GraphNode in graph.graph_nodes.values():
		if node == graph.graph_nodes[1]:
			continue
		
		#We only iter levels down if node is starting node
		# we detect this by seeing if owner_id is -1 (applies for detached trees and world node)
		if node.confed.Owner_ID == -1:
			#We know we have a root node here, we have to iterate down now
			var queue: Array[GraphNode]
			var curr_node: GraphNode;
			queue.push_back(node);
	
			while not queue.is_empty():
				# Pop node off queue
				curr_node = queue.pop_front();
				
				#Get Children of current node
				var children: Array = curr_node.confed.Children_ID;
				
				for child_id: int in children:
					# Add each child to queue
					var child_node: GraphNode = graph.graph_nodes[child_id];
					queue.push_back(child_node)
					
					#Connect Child to Owner
					graph_edit.connect_node(child_node.name, 0, curr_node.name, 0);
					#world_map.propagate_country_list(curr_node);
		else:
			continue;
