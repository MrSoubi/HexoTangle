class_name Hexomino

var position: Vector2
var dir: GlobalData.Direction
var type: GlobalData.HexType
var texture: Texture2D

func _init(position: Vector2, dir: GlobalData.Direction, type: GlobalData.HexType, texture: Texture2D):
	self.position = position;
	self.dir = dir;
	self.type = type;
	self.texture = texture;

func addDirections(dir1: GlobalData.Direction, dir2: GlobalData.Direction) -> GlobalData.Direction:
	var val1 = int(dir1);
	var val2 = int(dir2);
	
	var result: GlobalData.Direction;
	
	match (val1 + val2) % 6:
		0:
			result = GlobalData.Direction.TOP
		1:
			result = GlobalData.Direction.TOP_RIGHT
		2:
			result = GlobalData.Direction.BOTTOM_RIGHT
		3:
			result = GlobalData.Direction.BOTTOM
		4:
			result = GlobalData.Direction.BOTTOM_LEFT
		5:
			result = GlobalData.Direction.TOP_LEFT
	
	return result;

func getNeighbourFromPosition(position: Vector2, direction: GlobalData.Direction) -> Vector2:
	var localX;
	var localY;
	
	match direction:
		GlobalData.Direction.TOP:
			localX = position.x - 1;
			localY = position.y;
		GlobalData.Direction.TOP_RIGHT:
			localX = position.x - int(int(position.y) % 2 == 0);
			localY = position.y + 1;
		GlobalData.Direction.BOTTOM_RIGHT:
			localX = position.x + int(int(position.y) % 2 == 1);
			localY = position.y + 1;
		GlobalData.Direction.BOTTOM:
			localX = position.x + 1;
			localY = position.y;
		GlobalData.Direction.BOTTOM_LEFT:
			localX = position.x + int(int(position.y) % 2 == 1);
			localY = position.y - 1;
		GlobalData.Direction.TOP_LEFT:
			localX = position.x - int(int(position.y) % 2 == 0);
			localY = position.y - 1;
	
	return Vector2(localX, localY);

func getNeighbour(direction: GlobalData.Direction) -> Vector2:
	var localX;
	var localY;
	
	match direction:
		GlobalData.Direction.TOP:
			localX = position.x - 1;
			localY = position.y;
		GlobalData.Direction.TOP_RIGHT:
			localX = position.x - int(int(position.y) % 2 == 0);
			localY = position.y + 1;
		GlobalData.Direction.BOTTOM_RIGHT:
			localX = position.x + int(int(position.y) % 2 == 1);
			localY = position.y + 1;
		GlobalData.Direction.BOTTOM:
			localX = position.x + 1;
			localY = position.y;
		GlobalData.Direction.BOTTOM_LEFT:
			localX = position.x + int(int(position.y) % 2 == 1);
			localY = position.y - 1;
		GlobalData.Direction.TOP_LEFT:
			localX = position.x - int(int(position.y) % 2 == 0);
			localY = position.y - 1;
	
	return Vector2(localX, localY);

func move(direction_test: GlobalData.Direction):
	position = getNeighbour(direction_test);

func moveLeft():
	if int(position.y) % 2 == 0:
		move(GlobalData.Direction.BOTTOM_LEFT);
	else:
		move(GlobalData.Direction.TOP_LEFT);

func moveRight():
	#move(Direction.BOTTOM_RIGHT);
	if int(position.y) % 2 == 0:
		move(GlobalData.Direction.BOTTOM_RIGHT);
	else:
		move(GlobalData.Direction.TOP_RIGHT);

func rotateClockwise():
	dir = (dir + 1) % 6;

func rotateAntiClockwise():
	dir = (dir - 1) % 6;
	if (dir < 0):
		dir += 6

func getPositions() -> Array:
	var positions = [];
	
	match type:
		GlobalData.HexType.I:
			positions.append(self.position);
			positions.append(getNeighbour(addDirections(GlobalData.Direction.TOP_RIGHT, dir)));
			positions.append(getNeighbour(addDirections(GlobalData.Direction.BOTTOM_LEFT, dir)));
			positions.append(getNeighbourFromPosition(positions[2], addDirections(GlobalData.Direction.BOTTOM_LEFT, dir)));
		GlobalData.HexType.O:
			positions.append(self.position);
			positions.append(getNeighbour(addDirections(GlobalData.Direction.BOTTOM, dir)));
			positions.append(getNeighbour(addDirections(GlobalData.Direction.BOTTOM_RIGHT, dir)));
			positions.append(getNeighbourFromPosition(positions[2], addDirections(GlobalData.Direction.BOTTOM, dir)));
		GlobalData.HexType.T:
			positions.append(self.position);
			positions.append(getNeighbour(addDirections(GlobalData.Direction.TOP, dir)));
			positions.append(getNeighbour(addDirections(GlobalData.Direction.BOTTOM_LEFT, dir)));
			positions.append(getNeighbour(addDirections(GlobalData.Direction.BOTTOM_RIGHT, dir)));
		GlobalData.HexType.L:
			positions.append(self.position);
			positions.append(getNeighbour(addDirections(GlobalData.Direction.TOP_LEFT, dir)));
			positions.append(getNeighbour(addDirections(GlobalData.Direction.BOTTOM_RIGHT, dir)));
			positions.append(getNeighbourFromPosition(positions[2], addDirections(GlobalData.Direction.TOP_RIGHT, dir)));
		GlobalData.HexType.J:
			positions.append(self.position);
			positions.append(getNeighbour(addDirections(GlobalData.Direction.TOP_RIGHT, dir)));
			positions.append(getNeighbour(addDirections(GlobalData.Direction.BOTTOM_LEFT, dir)));
			positions.append(getNeighbourFromPosition(positions[2], addDirections(GlobalData.Direction.TOP_LEFT, dir)));
		GlobalData.HexType.Z:
			positions.append(self.position);
			positions.append(getNeighbour(addDirections(GlobalData.Direction.TOP, dir)));
			positions.append(getNeighbour(addDirections(GlobalData.Direction.BOTTOM_LEFT, dir)));
			positions.append(getNeighbourFromPosition(positions[2], addDirections(GlobalData.Direction.TOP_LEFT, dir)));
		GlobalData.HexType.S:
			positions.append(self.position);
			positions.append(getNeighbour(addDirections(GlobalData.Direction.TOP, dir)));
			positions.append(getNeighbour(addDirections(GlobalData.Direction.BOTTOM_RIGHT, dir)));
			positions.append(getNeighbourFromPosition(positions[2], addDirections(GlobalData.Direction.BOTTOM, dir)));
	
	return positions;
