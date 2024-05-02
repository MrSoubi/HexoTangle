extends Node

var bag = [
	GlobalData.HexType.I,
	GlobalData.HexType.O,
	GlobalData.HexType.T,
	GlobalData.HexType.L,
	GlobalData.HexType.J,
	GlobalData.HexType.Z,
	GlobalData.HexType.S
	];

func getRandomHexType() -> GlobalData.HexType:
	var k = bag[randi_range(0, bag.size()-1)];
	bag.erase(k);
	
	if (bag.size() == 0):
		fill_bag();
	
	return k;

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
