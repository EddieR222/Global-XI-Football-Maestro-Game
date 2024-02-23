class_name Graph extends Resource

@export var graph_nodes: Dictionary


"""
All functions below are for adding nodes and edges
"""
func add_node(new_node: GraphNode) -> void:
	# Edit default values such as level 
	new_node.confed.ID = graph_nodes.size();
	new_node.confed.Name = "New Confederation";
	new_node.confed.Level = 1;
	new_node.confed.Owner_ID = -1;
	
	# Now we place it into the graph_nodes dictionary
	graph_nodes[new_node.confed.ID] = new_node;

	
	
func add_edge(a: GraphNode, b: GraphNode) -> int:
	b.confed.Owner_ID 
	# Now we should have the the GNodes of both A and B
	return 0;
		
	
"""
Functions below are for the deletion of nodes and edges, even clearing all nodes and edges
"""

func delete_node(a: GraphNode) -> void:
	# First we want to delete any connections it may have
	for node: GraphNode in graph_nodes.values():
		if node == graph_nodes[1]:
			continue
		if node.confed.Owner_ID == a.confed.ID:
			node.confed.Owner_ID = -1;
		if a.confed.ID in node.confed.Children_ID:
			node.confed.Children_ID.erase(a.confed.ID);
			node.confed.Children_ID.erase(a.confed.ID);
			node.confed.Children_ID.erase(a.confed.ID);
	
	# Second, we want to delete the node from the graph_nodes	
	organize_confeds(a.confed.ID)
	
	
	
func delete_edge(a: GraphNode, b: GraphNode) -> void:
	a.confed.Owner_ID = -1;

	
func clear() -> void:
	graph_nodes.clear();
	
	
func clear_edges() -> void:
	for node: GraphNode in graph_nodes.values():
		if node == graph_nodes[1]:
			continue
		if node.confed.Level != 0:
			node.confed.Owner_ID = -1;
			node.confed.Children_ID.clear();
	
	
"""
Functions below are for quick checks, all return boolean values
"""
func has_edge(a: GraphNode, b: GraphNode) -> bool:
	# Since this graph is directed, it should be a -> b
	if a.confed.Owner_ID == b.confed.ID:
		return true;
	return false
	
func has_node(a: GraphNode) -> bool:
	if a in graph_nodes.values():
		return true;
	else:
		return false;



"""
Functions below are to get simple information such as size, level, etcs
"""
func get_edge_count() -> int:
	var edge_count: int  = 0;
	for node: GraphNode in graph_nodes.values():
		if node == graph_nodes[1]:
			continue
		if node.confed.Level != 0 and node.confed.Owner_ID != 1:
			edge_count += 1;
	return edge_count; 

func get_node_count() -> int:
	return graph_nodes.size();
	
func get_node_list() -> Array:
	return graph_nodes.values();
	
func get_node_id(index: int) -> int:
	var confed: Confederation = graph_nodes[index].confed;
	return confed.ID;
	
func get_confed_name(index: int) -> String:
	var confed: Confederation = graph_nodes[index].confed;
	return confed.Name;
	
func get_node_level(index: int) -> int:
	var confed: Confederation = graph_nodes[index].confed;
	return confed.Level;
	
func get_node_owner_id(index: int) -> int:
	var confed: Confederation = graph_nodes[index].confed;
	return confed.Owner_ID;
	
func get_node_territory_list(index: int) -> Dictionary:
	var confed: Confederation = graph_nodes[index].confed;
	return confed.Territory_List;
	
func get_node(index: int) -> GraphNode:
	return graph_nodes[index];
	
func get_territory_num() -> int:
	var terrtories : Array = [];
	for node: GraphNode in graph_nodes.values():
		if node == graph_nodes[1]:
			continue
		for terr: Territory in node.confed.Territory_List.values():
			if terr.Territory_ID not in terrtories:
				terrtories.push_back(terr.Territory_ID);
	return terrtories.size();

	
"""
Functions below are for finding connections between nodes or cycles or propagating info. Essentially anything
to do with traversing the graph
"""
func are_connected(a: GraphNode, b:GraphNode) -> bool:
	
	if a.confed.Owner_ID == -1:
		return false #Nothing to do, so return
	# This function simply sees if two nodes are connected
	var curr_node: GraphNode;
	curr_node = a;
	
	while curr_node.confed.Level != 0: # or curr_node.confed.Owner_ID != 0:
		# Reach end of edges, even if not world node, we exit
		if curr_node.confed.Owner_ID == -1:
			break
		# If next node is b, we return true since they are connected	
		if curr_node.confed.Owner_ID == b.confed.ID:
			return true
		# Iter	
		curr_node = graph_nodes[curr_node.confed.Owner_ID];
	return false;
		
	
func shortest_path(a: GraphNode, b: GraphNode) -> Array:
	return [];
	
	
func propagate_country_list(node: GraphNode) -> void:
	# First, we simply check if there even are any higher level nodes
	if node.confed.Owner_ID == -1:
		return #Nothing to do, so return
	# Set current node as given node
	var curr_node: GraphNode = node;
	
	while curr_node.confed.Level != 0: #or curr_node.confed.Owner_ID != 0:
		# First, we simply check if there even are any higher level nodes
		if curr_node.confed.Owner_ID == -1:
			return #Nothing to do, so return
		
		var territory_list: Dictionary = curr_node.confed.Territory_List;
		var owner_node: GraphNode = graph_nodes[curr_node.confed.Owner_ID];
		
		for terr: Territory in territory_list.values():
			# Get ItemList of GraphNode in order to add items to it 
			# for each new territory added
			var itemlist: ItemList = owner_node.get_node("HBoxContainer/ItemList");
			
			# If territory is already in owner territory list, skip to avoid duplicating territories
			if terr in owner_node.confed.Territory_List.values():
				continue;
				
			# Now we can add item 
			itemlist.add_item(terr.Territory_Name, null, true);
			var new_index: int = owner_node.confed.Territory_List.size(); 
			
			# Finally, we store it into owner node territory list
			owner_node.confed.Territory_List[new_index] = terr;
		# Once we added countries, we simply reflect changes and update curr_node	
		owner_node.reflect_territory_changes();
		curr_node = owner_node;
		
func update_graph() -> void:
	#TODO: Write this function, basically iterates through all nodes (except world and terr edit)
	# propagates all needed country list, levelm, connections, etc. This should in essense update everything 
	#almost like a refresh button
	
	#First we want to ensure all Level numbers are correct
	var visited: Array = [];
	var queue: Array = [];
	var curr_node: GraphNode = graph_nodes[0];
	while visited.size() < graph_nodes.size():
		break
	
	
	
	pass	
	
func compress_node_tracker(deleted_key: int):
	# Here we simply want to compress the dictionary so all nodes are in numerical order
	var index: int = deleted_key;
	while index + 1 in graph_nodes.keys():
		var temp_node: GraphNode = graph_nodes[index + 1];
		graph_nodes[index] = temp_node;
		index += 1;
	graph_nodes.erase(index); 



"""
Following Functioncs are specific to the terr_edit_node at index 1
"""

func is_terr_edit_visible() -> bool:
	return graph_nodes[1].visible;

func toggle_terr_edit_visiblity() -> bool:
	# Negate current status and return new status
	if graph_nodes[1].visible == true:
		graph_nodes[1].visible = false;
		return false;
	else:
		graph_nodes[1].visible = true;
		return true;
		
	
	

			
"""
FOllowing Functions propagate changes anf organize everything to maintain consistency
"""
# This function ensures confederation ID's stay linear 
func organize_confeds(deleted_key: int) -> void:
	var index: int = deleted_key;
	while index + 1 in graph_nodes.keys():
		# Get next Node, and make it current node
		var temp_node: GraphNode = graph_nodes[index + 1];
		graph_nodes[index] = temp_node;
		
		#Next we have to propagate this change everywhere in Owner and Children IDs
		var previous_id: int = index + 1;
		for node: GraphNode in graph_nodes.values():
			if node == graph_nodes[1]:
				continue
			if node.confed.Owner_ID == previous_id:
				node.confed.Owner_ID = index;
			if previous_id in node.confed.Children_ID:
				node.confed.Children_ID.erase(previous_id);
				node.confed.Children_ID.push_back(index)
		
		#Next, relfect this change into the confederation
		graph_nodes[index].confed.ID = index
		
		# Iter Index
		index += 1;
	#Finally, erase last index as this is a duplicate
	graph_nodes.erase(index); 
	
func organize_all_territories() -> void:
	#Here we will iterate through all GraphNodes in the graph_nodes
	for node: GraphNode in graph_nodes.values():
		if node == graph_nodes[1]:
			continue
		
		organize_specific_territories(node);
		
func organize_specific_territories(node: GraphNode) -> void:
	var terr_list: Dictionary = node.confed.Territory_List.duplicate();
	var item_list: ItemList = node.get_node("HBoxContainer/ItemList");
	var terr_array: Array = terr_list.values();
	
	
	#First we sort the countries in the list
	terr_array.sort_custom(func(a, b): return a.Territory_Name < b.Territory_Name);
	
	#Then we place them into the dictionary, in ascending number order (0, 1, 2, 3 ...)
	var new_terr_list: Dictionary = {};
	for terr: Territory in terr_array:
		new_terr_list[new_terr_list.size()] = terr;
		
	#Finally, we place back into territory list in confederation
	node.confed.Territory_List = new_terr_list;
	
	node.reflect_territory_changes();

# This funtions ensures all Levels of confederations are consistent, regardless of confed deletions
func organize_levels() -> void:
	# Iter through all nodes
	for node: GraphNode in graph_nodes.values():
		if node == graph_nodes[1]:
			continue
		
		#We only iter levels down if node is starting node
		# we detect this by seeing if owner_id is -1 (applies for detached trees and world node)
		if node.confed.Owner_ID == -1:
			#We know we have a root node here, we have to iterate down now
			var queue: Array[GraphNode]
			var curr_node: GraphNode;
			
			#For non-world nodes, we set the new level to 1
			if node != graph_nodes[0]:
				node.set_confed_level(1);
			queue.push_back(node);
	
			while not queue.is_empty():
				# Pop node off queue
				curr_node = queue.pop_front();
				
				#Get Children of current node
				var children: Array[int] = curr_node.confed.Children_ID;
				
				for child_id: int in children:
					# Add each child to queue
					var child_node: GraphNode = graph_nodes[child_id];
					queue.push_back(child_node)
					
					#Set New Level Number
					graph_nodes[child_id].set_confed_level(curr_node.confed.Level + 1);
					
		else:
			continue;			




	

