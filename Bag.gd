extends Node

@onready var ui = $"../UI"

var bag = [
	GlobalData.HexType.I,
	GlobalData.HexType.O,
	GlobalData.HexType.T,
	GlobalData.HexType.L,
	GlobalData.HexType.J,
	GlobalData.HexType.Z,
	GlobalData.HexType.S
	]

var queue = []

func fill_bag():
	bag = [
	GlobalData.HexType.I,
	GlobalData.HexType.O,
	GlobalData.HexType.T,
	GlobalData.HexType.L,
	GlobalData.HexType.J,
	GlobalData.HexType.Z,
	GlobalData.HexType.S
	];

func fill_queue():
	queue.append(get_random_hex_type())
	queue.append(get_random_hex_type())
	queue.append(get_random_hex_type())
	queue.append(get_random_hex_type())
	queue.append(get_random_hex_type())
	queue.append(get_random_hex_type())
	
	ui.add_figure_to_queue(queue[0])
	ui.add_figure_to_queue(queue[1])
	ui.add_figure_to_queue(queue[2])
	ui.add_figure_to_queue(queue[3])
	ui.add_figure_to_queue(queue[4])
	ui.add_figure_to_queue(queue[5])

func get_random_hex_type() -> GlobalData.HexType:
	var k = bag[randi_range(0, bag.size()-1)];
	bag.erase(k);
	
	if (bag.size() == 0):
		fill_bag();
	
	return k;

func get_next_hex_type() -> GlobalData.HexType:
	var result = queue.pop_back()
	queue.push_front(get_random_hex_type())
	
	ui.add_figure_to_queue(queue[0])
	
	return result
