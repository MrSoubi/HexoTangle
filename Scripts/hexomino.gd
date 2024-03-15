class_name Hexomino

enum Direction {TOP = 0, TOP_RIGHT = 1, BOTTOM_RIGHT = 2, BOTTOM = 3, BOTTOM_LEFT = 4, TOP_LEFT = 5}

enum HexType {I, O, T, L, J, Z, S};

var position: Vector2
var dir: Direction
var type: HexType
var texture: Texture2D

func _init(position: Vector2, dir: Direction, type: HexType, texture: Texture2D):
	self.position = position;
	self.dir = dir;
	self.type = type;
	self.texture = texture;

func addDirections(dir1: Direction, dir2: Direction) -> Direction:
	var val1 = int(dir1);
	var val2 = int(dir2);
	
	var result: Direction;
	
	match (val1 + val2) % 6:
		0:
			result = Direction.TOP
		1:
			result = Direction.TOP_RIGHT
		2:
			result = Direction.BOTTOM_RIGHT
		3:
			result = Direction.BOTTOM
		4:
			result = Direction.BOTTOM_LEFT
		5:
			result = Direction.TOP_LEFT
	
	return result;

func getNeighbourFromPosition(position: Vector2, direction: Direction) -> Vector2:
	var localX;
	var localY;
	
	match direction:
		Direction.TOP:
			localX = position.x - 1;
			localY = position.y;
		Direction.TOP_RIGHT:
			localX = position.x - int(int(position.y) % 2 == 0);
			localY = position.y + 1;
		Direction.BOTTOM_RIGHT:
			localX = position.x + int(int(position.y) % 2 == 1);
			localY = position.y + 1;
		Direction.BOTTOM:
			localX = position.x + 1;
			localY = position.y;
		Direction.BOTTOM_LEFT:
			localX = position.x + int(int(position.y) % 2 == 1);
			localY = position.y - 1;
		Direction.TOP_LEFT:
			localX = position.x - int(int(position.y) % 2 == 0);
			localY = position.y - 1;
	
	return Vector2(localX, localY);

func getNeighbour(direction: Direction) -> Vector2:
	var localX;
	var localY;
	
	match direction:
		Direction.TOP:
			localX = position.x - 1;
			localY = position.y;
		Direction.TOP_RIGHT:
			localX = position.x - int(int(position.y) % 2 == 0);
			localY = position.y + 1;
		Direction.BOTTOM_RIGHT:
			localX = position.x + int(int(position.y) % 2 == 1);
			localY = position.y + 1;
		Direction.BOTTOM:
			localX = position.x + 1;
			localY = position.y;
		Direction.BOTTOM_LEFT:
			localX = position.x + int(int(position.y) % 2 == 1);
			localY = position.y - 1;
		Direction.TOP_LEFT:
			localX = position.x - int(int(position.y) % 2 == 0);
			localY = position.y - 1;
	
	return Vector2(localX, localY);

func move(direction: Direction):
	position = getNeighbour(direction);

func moveLeft():
	if int(position.y) % 2 == 0:
		move(Direction.BOTTOM_LEFT);
	else:
		move(Direction.TOP_LEFT);

func moveRight():
	#move(Direction.BOTTOM_RIGHT);
	if int(position.y) % 2 == 0:
		move(Direction.BOTTOM_RIGHT);
	else:
		move(Direction.TOP_RIGHT);

func rotateClockwise():
	dir = (dir + 1) % 6;

func rotateAntiClockwise():
	dir = (dir - 1) % 6;
	if (dir < 0):
		dir += 6

func getPositions() -> Array:
	var positions = [];
	
	match type:
		HexType.I:
			positions.append(self.position);
			positions.append(getNeighbour(addDirections(Direction.TOP_LEFT, dir)));
			positions.append(getNeighbour(addDirections(Direction.BOTTOM_RIGHT, dir)));
			positions.append(getNeighbourFromPosition(positions[2], addDirections(Direction.BOTTOM_RIGHT, dir)));
		HexType.O:
			positions.append(self.position);
			positions.append(getNeighbour(addDirections(Direction.BOTTOM, dir)));
			positions.append(getNeighbour(addDirections(Direction.BOTTOM_RIGHT, dir)));
			positions.append(getNeighbourFromPosition(positions[2], addDirections(Direction.BOTTOM, dir)));
		HexType.T:
			positions.append(self.position);
			positions.append(getNeighbour(addDirections(Direction.TOP, dir)));
			positions.append(getNeighbour(addDirections(Direction.BOTTOM_LEFT, dir)));
			positions.append(getNeighbour(addDirections(Direction.BOTTOM_RIGHT, dir)));
		HexType.L:
			positions.append(self.position);
			positions.append(getNeighbour(addDirections(Direction.TOP_LEFT, dir)));
			positions.append(getNeighbour(addDirections(Direction.BOTTOM_RIGHT, dir)));
			positions.append(getNeighbourFromPosition(positions[2], addDirections(Direction.TOP_RIGHT, dir)));
		HexType.J:
			positions.append(self.position);
			positions.append(getNeighbour(addDirections(Direction.TOP_RIGHT, dir)));
			positions.append(getNeighbour(addDirections(Direction.BOTTOM_LEFT, dir)));
			positions.append(getNeighbourFromPosition(positions[2], addDirections(Direction.TOP_LEFT, dir)));
		HexType.Z:
			positions.append(self.position);
			positions.append(getNeighbour(addDirections(Direction.TOP, dir)));
			positions.append(getNeighbour(addDirections(Direction.BOTTOM_LEFT, dir)));
			positions.append(getNeighbourFromPosition(positions[2], addDirections(Direction.TOP_LEFT, dir)));
		HexType.S:
			positions.append(self.position);
			positions.append(getNeighbour(addDirections(Direction.TOP, dir)));
			positions.append(getNeighbour(addDirections(Direction.BOTTOM_RIGHT, dir)));
			positions.append(getNeighbourFromPosition(positions[2], addDirections(Direction.BOTTOM, dir)));
	
	return positions;
