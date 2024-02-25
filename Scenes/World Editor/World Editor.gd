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
	var world_map: WorldMap = $"VBoxContainer/Confed Edit".world_map
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
		
	graph_edit.world_map.clear();
	
	#Load the World Map
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
		if confed.Name == "World":
			var world_confed_node: GraphNode = graph_edit.establish_world_node();
			world_confed_node.confed = confed
			var item_list: ItemList = world_confed_node.get_node("HBoxContainer/ItemList");
			for terr: Territory in confed.Territory_List.values():
				print(terr.Territory_Name);
				# Get Territory Name
				var terr_name = terr.Territory_Name;
				# Get Territory Flag or Icon
				var texture_normal
				var flag = terr.Flag;
				if flag != null:
					flag.decompress();
					texture_normal = ImageTexture.create_from_image(flag);
				else:
					var default_icon: CompressedTexture2D = load("res://Images/icon.svg");
					texture_normal = default_icon;
				item_list.add_item(terr_name, texture_normal, true);
			world_map.organize_specific_territories(world_confed_node);
			world_map.graph_nodes[0] = world_confed_node;
			
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
		var new_node: GraphNode = confed_node.instantiate(); 
		graph_edit.add_child(new_node);
		graph_edit.enable_slots(new_node)
		new_node.position_offset = pos;
		new_node.confed = confed
		world_map.graph_nodes[world_map.graph_nodes.size()] = new_node
	for node: GraphNode in world_map.graph_nodes.values():
		if node == world_map.graph_nodes[1]:
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
					var child_node: GraphNode = world_map.graph_nodes[child_id];
					queue.push_back(child_node)
					
					#Connect Child to Owner
					graph_edit.connect_node(child_node.name, 0, curr_node.name, 0);
					#world_map.propagate_country_list(curr_node);
		else:
			continue;		
	graph_edit.world_map = world_map;
	print("Done");
	#for confed: Confederation in file_map.Confederations.values():
		#var pos: Vector2;
		#match confed.Level:
			#0:
				#pos = Vector2(0,0);
				## We want to establish the world node and ensure it has the right properties
				#var world_confed_node: GraphNode = graph_edit.establish_world_node();
				#
				## We also have to instantiate the country editor, there will only be one in the entire document and it will follow 
				## the confederation node that activated it.
				#var terr_edit_node: GraphNode = terr_node.instantiate();
				#graph_edit.add_child(terr_edit_node);
				#terr_edit_node.visible = 0;
				#
				## Now we connect the territory edit node to the correct signals here
				#graph_edit.connect_signals_from_territory_node(terr_edit_node);
				#
				##Finally we add these nodes to the nodes tracker to be able to manpulate them later
				#world_map.graph_nodes[0] = world_confed_node;
				#world_map.graph_nodes[1] = terr_edit_node;
				#
				## Add territories to World Node
				#for terr: Territory in confed.Territory_List.values():
					#var item_list: ItemList = world_confed_node.get_node("HBoxContainer/ItemList");
					#
					## Get Territory Name
					#var terr_name = terr.Territory_Name;
					## Get Territory Flag or Icon
					#var texture_normal
					#var flag = terr.Flag;
					#if flag != null:
						#flag.decompress();
						#texture_normal = ImageTexture.create_from_image(flag);
					#else:
						#var default_icon: CompressedTexture2D = load("res://Images/icon.svg");
						#texture_normal = default_icon;
					#item_list.add_item(terr_name, texture_normal, true);
					#
				#graph_edit.world_map.organize_specific_territories(world_confed_node);
				#world_confed_node.reflect_territory_changes();
				#
			#1:
				#pos = Vector2(starting_x_positions[1], 1 * 600)
				#starting_x_positions[1] += 1200
			#2:
				#pos = Vector2(starting_x_positions[2], 2 * 600)
				#starting_x_positions[2] += 1200
			#3:
				#pos = Vector2(starting_x_positions[3], 3 * 600)
				#starting_x_positions[3] += 1200
			#4:
				#pos = Vector2(starting_x_positions[4], 4 * 600)
				#starting_x_positions[4] += 1200
			#5:
				#pos = Vector2(starting_x_positions[5], 5 * 600)
				#starting_x_positions[5] += 1200
			#6:
				#pos = Vector2(starting_x_positions[6], 6 * 600)
				#starting_x_positions[6] += 1200
			#7:
				#pos = Vector2(starting_x_positions[7], 7 * 600)
				#starting_x_positions[7] += 1200
			#8:
				#pos = Vector2(starting_x_positions[8], 8 * 600)
				#starting_x_positions[8] += 1200
			#9:
				#pos = Vector2(starting_x_positions[9], 9 * 600)
				#starting_x_positions[9] += 1200
		#
		## To show each confed, we need to instantiate a graphnode
		## Get Node from preloaded scene, and add to tree
		#if confed.Level == 0:
			#continue
		#var new_node: GraphNode = confed_node.instantiate(); 
		#graph_edit.add_child(new_node);
		#new_node.position_offset = pos;
		#
		## Now we connect all needed signals 
		#graph_edit.connect_signals_from_confed_node(new_node);
		#
			#
		## Now we add this node to the node_tracker so we can track it
		#new_node.confed = confed;
		## Now we place it into the graph_nodes dictionary
		#world_map.graph_nodes[new_node.confed.ID] = new_node;
		#
		##Set Confed Level
		#new_node.set_confed_level(confed.Level)
		#
		##Set Confed Name
		#var name_edit: LineEdit = new_node.get_node("HBoxContainer2/LineEdit");
		#name_edit.text = confed.Name;
		#
		##Enable Slots for all added nodes
		#graph_edit.enable_slots(new_node)
		#
		#for terr: Territory in confed.Territory_List.values():
			#var item_list: ItemList = new_node.get_node("HBoxContainer/ItemList");
			#
			## Get Territory Name
			#var terr_name = terr.Territory_Name;
			## Get Territory Flag or Icon
			#var texture_normal
			#var flag = terr.Flag;
			#if flag != null:
				#flag.decompress();
				#texture_normal = ImageTexture.create_from_image(flag);
			#else:
				#var default_icon: CompressedTexture2D = load("res://Images/icon.svg");
				#texture_normal = default_icon;
			#item_list.add_item(terr_name, texture_normal, true);
		#graph_edit.world_map.organize_specific_territories(new_node);
		#new_node.reflect_territory_changes();
		#
	#world_map.organize_levels();
	##world_map.organize_all_territories();
	#
	## Now we go through all the nodes and connect them
	#for node: GraphNode in world_map.graph_nodes.values():
		#if node == world_map.graph_nodes[1]:
			#continue
		#
		##We only iter levels down if node is starting node
		## we detect this by seeing if owner_id is -1 (applies for detached trees and world node)
		#if node.confed.Owner_ID == -1:
			##We know we have a root node here, we have to iterate down now
			#var queue: Array[GraphNode]
			#var curr_node: GraphNode;
			#queue.push_back(node);
	#
			#while not queue.is_empty():
				## Pop node off queue
				#curr_node = queue.pop_front();
				#
				##Get Children of current node
				#var children: Array[int] = curr_node.confed.Children_ID;
				#
				#for child_id: int in children:
					## Add each child to queue
					#var child_node: GraphNode = world_map.graph_nodes[child_id];
					#queue.push_back(child_node)
					#
					##Connect Child to Owner
					#graph_edit.connect_node(child_node.name, 0, curr_node.name, 0);
					#world_map.propagate_country_list(curr_node);
		#else:
			#continue;			
	#
	#
	#world_map.organize_all_territories();
	#graph_edit.world_map = world_map;
		#
