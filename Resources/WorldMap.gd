class_name WorldMap extends Resource


@export var Confederations: Dictionary

func save_confederations(graph: Dictionary):
	for node: GraphNode in graph.values():
		if node == graph[1]:
			continue
		Confederations[node.confed.ID] = node.confed.duplicate();
		
	
