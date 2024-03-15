extends Node2D

var textureFree: Texture2D = load("res://Sprites/Hexagon_White.png");
var textureBlocked: Texture2D = load("res://Sprites/Hexagon_Black.png");
var textureMoving: Texture2D = load("res://Sprites/Hexagon_Blue.png");
var texture_O: Texture2D = load("res://Sprites/Hex_Yellow.png")
var texture_I: Texture2D = load("res://Sprites/Hex_Blue.png")
var texture_T: Texture2D = load("res://Sprites/Hex_Purple.png")
var texture_L: Texture2D = load("res://Sprites/Hex_Orange.png")
var texture_J: Texture2D = load("res://Sprites/Hex_DarkBlue.png")
var texture_S: Texture2D = load("res://Sprites/Hex_Green.png")
var texture_Z: Texture2D = load("res://Sprites/Hex_Red.png")

const GRID_HEIGHT: int = 21;
const GRID_WIDTH: int = 12;

const GRID_SCALE: float = 0.3;

const CELL_SIZE: float = 65.0 * GRID_SCALE; 
const CELL_HEIGHT: float = sqrt(3.0) * CELL_SIZE;
const CELL_WIDTH: float = 2.0 * CELL_SIZE;
const VERTICAL_SPACING: float = 0.5 * CELL_HEIGHT;
const HORIZONTAL_SPACING: float = 0.75 * CELL_WIDTH;

const ORIGIN: Vector2 = Vector2(100, 100);

enum Direction {TOP, TOP_RIGHT, BOTTOM_RIGHT, BOTTOM, BOTTOM_LEFT, TOP_LEFT}

enum HexType {I, O, T, L, J, Z, S};

var cell = load("res://Cell.tscn");
var hexomino = load("res://Scripts/hexomino.gd");

var gridDirection = Direction.TOP;

var currentHexomino;
var heldHexomino = -1;

var bag = [HexType.I, HexType.O, HexType.T, HexType.L, HexType.J, HexType.Z, HexType.S];
var grid = [];

# Called when the node enters the scene tree for the first time.
func _ready():
	#global_translate(get_viewport().size/2)
	
	# Generation of every cell and setting of the positions
	for n in range(GRID_HEIGHT):
		var r = [];
		for m in range(GRID_WIDTH):
			r.append(cell.instantiate());
			add_child(r[m]);
			r[m].position = Vector2(m * HORIZONTAL_SPACING - (GRID_WIDTH * HORIZONTAL_SPACING / 2.), (int(m % 2 == 1) + 2 * n) * VERTICAL_SPACING - (GRID_HEIGHT * VERTICAL_SPACING / 2.));
			#r[m].get_node("Label").text = str(n) + "," + str(m);
		grid.append(r);
	
	for row in range(GRID_HEIGHT):
		grid[row][0].setState(Cell.State.BLOCKED, textureBlocked)
		grid[row][GRID_WIDTH-1].setState(Cell.State.BLOCKED, textureBlocked)
	
	for col in range(GRID_WIDTH):
		grid[GRID_HEIGHT-1][col].setState(Cell.State.BLOCKED, textureBlocked)
	
	@warning_ignore("integer_division")
	var type = getRandomHexType()
	currentHexomino = hexomino.new(Vector2(3,GRID_WIDTH/2), Direction.TOP, type, GetTextureFromType(type));
	drawHexomino();

func drawHexomino():
	var localPositions = currentHexomino.getPositions();
	
	for i in range(4):
		var localCell = localPositions[i]
		grid[localCell.x][localCell.y].setState(Cell.State.MOVING, currentHexomino.texture)

func undrawHexomino():
	var localPositions = currentHexomino.getPositions();

	for i in range(4):
		var localCell = localPositions[i]
		grid[localCell.x][localCell.y].setState(Cell.State.FREE, textureFree)

func isInverseLineFull(row: int) -> bool:
	var result: bool = true;
	
	for i in range(GRID_WIDTH):
		if i%2 == 0:
			result = result && !grid[row][i].isEmpty();
		else:
			result = result && !grid[row-1][i].isEmpty();
	
	return result;
	
func isLineFull(row: int) -> bool:
	var result: bool = true;
	
	for i in range(GRID_WIDTH):
		result = result && !grid[row][i].isEmpty();
	
	return result;

func getFullLines() -> Array:
	var result = [];
	
	for i in range(GRID_HEIGHT):
		if (isLineFull(i) && i != GRID_HEIGHT-1):
			result.append(i);
	
	return result;

func getFullInverseLines() -> Array:
	var result = [];
	
	for i in range(GRID_HEIGHT):
		if (isInverseLineFull(i) && i != GRID_HEIGHT-1):
			result.append(i);
	
	return result;
	
func handleFullLines():
	var fullLines = getFullLines();
	
	for row in fullLines:
		removeLine(row);
	
	#fullLines = getFullInverseLines();
	
	for row in fullLines:
		#removeInverseLine(row);
		pass
	
	return fullLines.size();

func removeLine(row: int):
	if (row == 0):
		for col in range(1, GRID_WIDTH-1):
			grid[row][col].setState(Cell.State.FREE, textureFree);
	else:
		for col in range(1, GRID_WIDTH-1):
			grid[row][col].setState(grid[row-1][col].state, grid[row-1][col].get_node("Sprite2D").texture);
		removeLine(row-1)

func removeInverseLine(row: int):
	if (row == 0):
		for col in range(1, GRID_WIDTH-1):
			grid[row][col].setState(Cell.State.FREE, textureFree);
	else:
		for col in range(1, GRID_WIDTH-1):
			grid[row][col].setState(grid[row-1][col].state, grid[row-1][col].get_node("Sprite2D").texture);
		removeLine(row-1)
		
func isPositionValid(hex: Hexomino) -> bool:
	var positions = hex.getPositions()
	var result = true;
	
	for i in range(4):
		var localX = positions[i].x
		var localY = positions[i].y
		if (localX < grid.size() && localY < grid[0].size()):
			result = result && grid[localX][localY].state != Cell.State.BLOCKED
		else:
			result = false;
	
	return result;

func update() -> int:
	var score = 0;
	var localHex = hexomino.new(currentHexomino.position, currentHexomino.dir, currentHexomino.type, currentHexomino.texture);
	localHex.move(addDirections(Direction.BOTTOM, gridDirection));
	if isPositionValid(localHex):
		undrawHexomino();
		currentHexomino = localHex;
		drawHexomino();
	else:
		#undrawHexomino();
		blockHexomino();
		score = handleFullLines();
		@warning_ignore("integer_division")
		var type = getRandomHexType()
		currentHexomino = hexomino.new(Vector2(3,GRID_WIDTH/2), Direction.TOP, type, GetTextureFromType(type));
	
	match (score):
		1:
			score = 100
		2:
			score = 300
		3:
			score = 500
		4:
			score = 800
	
	return score;

func GetTextureFromType(type: HexType) -> Texture2D:
	var result: Texture2D;
	
	match(type):
		HexType.I:
			result = texture_I;
		HexType.O:
			result = texture_O;
		HexType.T:
			result = texture_T;
		HexType.L:
			result = texture_L;
		HexType.J:
			result = texture_J;
		HexType.Z:
			result = texture_Z;
		HexType.S:
			result = texture_S;
		
	return result;

func getRandomHexType() -> HexType:
	var k = bag[randi_range(0, bag.size()-1)];
	bag.erase(k);
	
	print(k)
	print(bag)
	
	if (bag.size() == 0):
		bag = [HexType.I, HexType.O, HexType.T, HexType.L, HexType.J, HexType.Z, HexType.S];
	
	return k;

func blockHexomino():
	var localPositions = currentHexomino.getPositions();
	
	for i in range(4):
		var localCell = localPositions[i]
		grid[localCell.x][localCell.y].setState(Cell.State.BLOCKED, currentHexomino.texture) 

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
	
func _input(event):
	if event is InputEventKey and event.pressed:
		var localHex = hexomino.new(currentHexomino.position, currentHexomino.dir, currentHexomino.type, currentHexomino.texture);
		
		if event.keycode == KEY_DOWN:
			localHex.move(addDirections(Direction.BOTTOM, gridDirection))
		if event.keycode == KEY_RIGHT:
			localHex.moveRight();
		if event.keycode == KEY_LEFT:
			localHex.moveLeft();
		#if event.keycode == KEY_UP:
			#localHex.move(addDirections(Direction.TOP, gridDirection));
		if event.keycode == KEY_UP:
			localHex = tryRotationAntiClockwise();
		if event.keycode == KEY_Z:
			localHex = tryRotationClockwise();
		if event.keycode == KEY_C:
			if (hold() == true):
				var type = getRandomHexType()
				localHex = hexomino.new(Vector2(3,GRID_WIDTH/2), Direction.TOP, type, GetTextureFromType(type));
			else:
				localHex = hexomino.new(Vector2(3,GRID_WIDTH/2), Direction.TOP, heldHexomino, heldHexomino.texture);
				heldHexomino = -1;
		#if event.keycode == KEY_I:
			#localHex.type = HexType.I;
		#if event.keycode == KEY_O:
			#localHex.type = HexType.O;
		#if event.keycode == KEY_T:
			#localHex.type = HexType.T;
		#if event.keycode == KEY_L:
			#localHex.type = HexType.L;
		#if event.keycode == KEY_J:
			#localHex.type = HexType.J;
		#if event.keycode == KEY_Z:
			#localHex.type = HexType.Z;
		#if event.keycode == KEY_S:
			#localHex.type = HexType.S;
		if event.keycode == KEY_SPACE:
			localHex = hardDrop();
		#if event.keycode == KEY_A:
			#rotateGrid();
		
		if isPositionValid(localHex):
			undrawHexomino();
			currentHexomino = localHex;
			drawHexomino();

func rotateGrid():
	gridDirection = addDirections(gridDirection, Direction.TOP_RIGHT);
	var tween = get_tree().create_tween()
	tween.tween_property(self, "rotation_degrees", self.rotation_degrees - 60, 0.08)
	#rotate(deg_to_rad(-60));
	#tween.tween_callback(self.queue_free)

func hardDrop() -> Hexomino:
	var localHex = hexomino.new(currentHexomino.position, currentHexomino.dir, currentHexomino.type, currentHexomino.texture);
	
	localHex.move(addDirections(Direction.BOTTOM, gridDirection));
	
	while (isPositionValid(localHex)):
		localHex.move(addDirections(Direction.BOTTOM, gridDirection));
	
	localHex.move(addDirections(Direction.TOP, gridDirection))
	return localHex;

func tryRotationAntiClockwise() -> Hexomino:
	var localHex = hexomino.new(currentHexomino.position, currentHexomino.dir, currentHexomino.type, currentHexomino.texture);
	var baseHex = hexomino.new(currentHexomino.position, currentHexomino.dir, currentHexomino.type, currentHexomino.texture);
	
	localHex.rotateAntiClockwise();
	
	if (!isPositionValid(localHex)):
		localHex.move(addDirections(Direction.TOP_LEFT, gridDirection));
	
		if (!isPositionValid(localHex)):
			localHex = baseHex;
			localHex.rotateAntiClockwise();
			localHex.move(addDirections(Direction.TOP_RIGHT, gridDirection));
		
			if (!isPositionValid(localHex)):
				localHex = baseHex;
				localHex.rotateAntiClockwise();
				localHex.move(addDirections(Direction.TOP, gridDirection));
	
	return localHex;

func tryRotationClockwise() -> Hexomino:
	var localHex = hexomino.new(currentHexomino.position, currentHexomino.dir, currentHexomino.type, currentHexomino.texture);
	var baseHex = hexomino.new(currentHexomino.position, currentHexomino.dir, currentHexomino.type, currentHexomino.texture);
	
	localHex.rotateClockwise();
	
	if (!isPositionValid(localHex)):
		localHex.move(addDirections(Direction.TOP_RIGHT, gridDirection));
	
		if (!isPositionValid(localHex)):
			localHex = baseHex;
			localHex.rotateClockwise();
			localHex.move(addDirections(Direction.TOP_LEFT, gridDirection));
		
			if (!isPositionValid(localHex)):
				localHex = baseHex;
				localHex.rotateClockwise();
				localHex.move(addDirections(Direction.TOP, gridDirection));
	
	return localHex;

func hold() -> bool:
	if (heldHexomino == -1):
		heldHexomino = currentHexomino.type
		return true;
	else:
		return false;
