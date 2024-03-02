class_name League_Graph extends Resource


@export var graph_nodes: Dictionary;


""" Adding Nodes """
func add_node(node: GraphNode) -> void:
	graph_nodes[graph_nodes.size()] = node;
	
func add_edge(a: GraphNode,b: GraphNode) -> void:
	# Set b as next_node in a
	a.Stage.Next_Stages.push_back(b.Stage.get_stage_id());
	
	# Set a as previous_node in b
	b.Stage.Previous_Stages.push_back(a.Stage.get_stage_id());





""" Tournament Conversion """
func turn_to_tournament() -> Tournament:
	var final_tour: Tournament = Tournament.new();
	
	
	return final_tour
