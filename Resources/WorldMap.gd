class_name WorldMap extends Resource

@export var graph_nodes: Dictionary
#@export var graph_edges: Dictionary 
 

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
			node.confed.ID = -1;
	
	# Second, we want to delete the node from the graph_nodes
	graph_nodes.erase(a.confed.ID)
	
		
	#compress_node_tracker(a.id)
	
	
	
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

"""
Functions below are for finding connections between nodes or cycles or propagating info. Essentially anything
to do with traversing the graph
"""
func are_connected(a: GraphNode, b:GraphNode) -> bool:
	# This function simply sees if two nodes are connected
	var curr_node: GraphNode;
	curr_node = a;
	
	
	while curr_node.confed.Level != 0 or curr_node.confed.Owner_ID != 0:
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
	if node.confed.Level == 0 and node.confed.Owner_ID == 0:
		return # World Node, return
		
	
	# Set current node as given node
	var curr_node: GraphNode = node;
	
	while curr_node.confed.Level != 0 or curr_node.confed.Owner_ID != 0:
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
		
func update_world_map() -> void:
	#TODO: Write this function, basically iterates through all nodes (except world and terr edit)
	# propagates all needed country list. This should in essense update everything 
	#almost like a refresh button
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
		
	
	

			








	

