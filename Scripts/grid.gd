extends Node2D

var textureFree: Texture2D = load("res://Sprites/Hex_Empty.png");
var textureBlocked: Texture2D = load("res://Sprites/Hex_Black.png");
var texture_O: Texture2D = load("res://Sprites/Hex_Yellow.png")
var texture_I: Texture2D = load("res://Sprites/Hex_Blue.png")
var texture_T: Texture2D = load("res://Sprites/Hex_Purple.png")
var texture_L: Texture2D = load("res://Sprites/Hex_Orange.png")
var texture_J: Texture2D = load("res://Sprites/Hex_DarkBlue.png")
var texture_S: Texture2D = load("res://Sprites/Hex_Green.png")
var texture_Z: Texture2D = load("res://Sprites/Hex_Red.png")
var texturePhantom : Texture2D = load("res://Sprites/Hex_Phantom.png")

var texture_Form_O: Texture2D = load("res://Sprites/Form_O.png")
var texture_Form_I: Texture2D = load("res://Sprites/Form_I.png")
var texture_Form_T: Texture2D = load("res://Sprites/Form_T.png")
var texture_Form_L: Texture2D = load("res://Sprites/Form_L.png")
var texture_Form_J: Texture2D = load("res://Sprites/Form_J.png")
var texture_Form_S: Texture2D = load("res://Sprites/Form_S.png")
var texture_Form_Z: Texture2D = load("res://Sprites/Form_Z.png")

var sfx_hardDrop: AudioStream = load("res://Sound/HardDrop.wav")
var sfx_softDrop: AudioStream = load("res://Sound/SoftDrop.wav")
var sfx_rotation: AudioStream = load("res://Sound/Rotation.wav")
var sfx_movement: AudioStream = load("res://Sound/Movement.wav")
var sfx_hold: AudioStream = load("res://Sound/Hold.wav")
var sfx_unhold: AudioStream = load("res://Sound/Unhold.wav")
var sfx_error: AudioStream = load("res://Sound/Error.wav")


const GRID_HEIGHT: int = 21;
const GRID_WIDTH: int = 12;

const GRID_SCALE: float = 0.3;

const CELL_SIZE: float = 65.0 * GRID_SCALE; 
const CELL_HEIGHT: float = sqrt(3.0) * CELL_SIZE;
const CELL_WIDTH: float = 2.0 * CELL_SIZE;
const VERTICAL_SPACING: float = 0.5 * CELL_HEIGHT;
const HORIZONTAL_SPACING: float = 0.75 * CELL_WIDTH;

const startingPosition = Vector2(1,GRID_WIDTH/2);

const ORIGIN: Vector2 = Vector2(100, 100);

enum Direction {TOP, TOP_RIGHT, BOTTOM_RIGHT, BOTTOM, BOTTOM_LEFT, TOP_LEFT}

enum HexType {I, O, T, L, J, Z, S};

var cell = load("res://Cell.tscn");
var hexomino = load("res://Scripts/hexomino.gd");
var sepLine = load("res://separation_line.tscn")

var gridDirection = Direction.TOP;

var currentHexomino;
var phantomHexomino;
var heldHexomino = -1;

var bag = [HexType.I, HexType.O, HexType.T, HexType.L, HexType.J, HexType.Z, HexType.S];
var grid = [];
var nextQueue = []; #stocks hextypes
var sepArray = []; # separation lines

var canHold: bool = true;

var score = 0;

var offsetX = -14.5
var offsetY = -18.4

# Called when the node enters the scene tree for the first time.
func _ready():
	# Separation lines
	for n in range(GRID_HEIGHT):
		sepArray.append(sepLine.instantiate())
		sepArray[n].scale = Vector2(0.31, 0.31)
		sepArray[n].position += Vector2(offsetX, ((n-5)*113*0.3) + offsetY)
		add_child(sepArray[n])
	
	# Generation of every cell and setting of the positions
	for n in range(GRID_HEIGHT):
		#sepArray[n].position = Vector2(0, 0)
		var r = [];
		for m in range(GRID_WIDTH):
			r.append(cell.instantiate());
			add_child(r[m]);
			r[m].position = Vector2(m * HORIZONTAL_SPACING - (GRID_WIDTH * HORIZONTAL_SPACING / 2.), (int(m % 2 == 1) + 2 * n) * VERTICAL_SPACING - (GRID_HEIGHT * VERTICAL_SPACING / 2.));
			
		grid.append(r);
	
	for row in range(GRID_HEIGHT):
		grid[row][0].setState(Cell.State.BLOCKED, textureBlocked)
		grid[row][GRID_WIDTH-1].setState(Cell.State.BLOCKED, textureBlocked)
	
	for col in range(GRID_WIDTH):
		grid[GRID_HEIGHT-1][col].setState(Cell.State.BLOCKED, textureBlocked)
	
	nextQueue.append(getRandomHexType());
	nextQueue.append(getRandomHexType());
	nextQueue.append(getRandomHexType());
	
	@warning_ignore("integer_division")
	var type = getNextHexomino()
	currentHexomino = hexomino.new(startingPosition, Direction.TOP, type, GetTextureFromType(type));


	$"../CanvasLayer/VBoxContainer2/ThirdUpcoming".texture = GetTextureFromHexType(nextQueue[2])
	$"../CanvasLayer/VBoxContainer2/SecondUpcoming".texture = GetTextureFromHexType(nextQueue[1])
	$"../CanvasLayer/VBoxContainer2/FirstUpcoming".texture = GetTextureFromHexType(nextQueue[0])
	
	drawHexomino();

func Reset():
	canHold = true;
	heldHexomino = -1;
	$"../CanvasLayer/VBoxContainer/Control/HoldLabel".texture = null;
	
	bag = [HexType.I, HexType.O, HexType.T, HexType.L, HexType.J, HexType.Z, HexType.S];
	nextQueue = []; #stocks hextypes
	nextQueue.append(getRandomHexType());
	nextQueue.append(getRandomHexType());
	nextQueue.append(getRandomHexType());
	
	score = 0;
	
	var type = getNextHexomino()
	currentHexomino = hexomino.new(startingPosition, Direction.TOP, type, GetTextureFromType(type));
	
	for n in range(GRID_HEIGHT):
		for m in range(GRID_WIDTH):
			grid[n][m].setState(Cell.State.FREE, textureFree)
	
	for row in range(GRID_HEIGHT):
		grid[row][0].setState(Cell.State.BLOCKED, textureBlocked)
		grid[row][GRID_WIDTH-1].setState(Cell.State.BLOCKED, textureBlocked)
	
	for col in range(GRID_WIDTH):
		grid[GRID_HEIGHT-1][col].setState(Cell.State.BLOCKED, textureBlocked)

func GetTextureFromHexType(t: HexType) -> Texture2D:
	var result;
	
	match(t):
		HexType.O:
			result = texture_Form_O
		HexType.I:
			result = texture_Form_I
		HexType.T:
			result = texture_Form_T
		HexType.L:
			result = texture_Form_L
		HexType.J:
			result = texture_Form_J
		HexType.S:
			result = texture_Form_S
		HexType.Z:
			result = texture_Form_Z
	
	return result

func drawPhantom():
	var localHex = hexomino.new(currentHexomino.position, currentHexomino.dir, currentHexomino.type, currentHexomino.texture);
	
	localHex.move(addDirections(Direction.BOTTOM, gridDirection));
	
	while (isPositionValid(localHex)):
		localHex.move(addDirections(Direction.BOTTOM, gridDirection));
	
	localHex.move(addDirections(Direction.TOP, gridDirection))
	
	phantomHexomino = localHex;
	
	var localPositions = phantomHexomino.getPositions();
	
	for i in range(4):
		var localCell = localPositions[i]
		grid[localCell.x][localCell.y].setState(Cell.State.FREE, texturePhantom)

func undrawPhantom():
	if (phantomHexomino != null):
		var localPositions = phantomHexomino.getPositions();
			
		for i in range(4):
			var localCell = localPositions[i]
			grid[localCell.x][localCell.y].setState(Cell.State.FREE, textureFree)

func drawHexomino():
	drawPhantom();
	var localPositions = currentHexomino.getPositions();
	
	for i in range(4):
		var localCell = localPositions[i]
		grid[localCell.x][localCell.y].setState(Cell.State.MOVING, currentHexomino.texture)

func undrawHexomino():
	undrawPhantom();
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
	var result;
	
	if (hex != null):
		var positions = hex.getPositions()
		result = true;
		
		for i in range(4):
			var localX = positions[i].x
			var localY = positions[i].y
			if (localX < grid.size() && localY < grid[0].size()):
				result = result && grid[localX][localY].state != Cell.State.BLOCKED
			else:
				result = false;
	else:
		result = false;
	
	return result;

func getNextHexomino() -> HexType:
	var result = nextQueue[0]
	nextQueue[0] = nextQueue[1]
	nextQueue[1] = nextQueue[2]
	nextQueue[2] = getRandomHexType()
	
	$"../CanvasLayer/VBoxContainer2/ThirdUpcoming".texture = GetTextureFromHexType(nextQueue[2])
	$"../CanvasLayer/VBoxContainer2/SecondUpcoming".texture = GetTextureFromHexType(nextQueue[1])
	$"../CanvasLayer/VBoxContainer2/FirstUpcoming".texture = GetTextureFromHexType(nextQueue[0])
	
	return result

func update() -> Vector2i:
	var localScore = score
	score = 0
	var lines = 0;
	
	var localHex = hexomino.new(currentHexomino.position, currentHexomino.dir, currentHexomino.type, currentHexomino.texture);
	localHex.move(addDirections(Direction.BOTTOM, gridDirection));
	if isPositionValid(localHex):
		undrawHexomino();
		currentHexomino = localHex;
		drawHexomino();
	else:
		#undrawHexomino();
		blockHexomino();
		lines = handleFullLines();
		@warning_ignore("integer_division")
		var type = getNextHexomino()
		currentHexomino = hexomino.new(startingPosition, Direction.TOP, type, GetTextureFromType(type));
	
	match (lines):
		1:
			localScore += 100
		2:
			localScore += 300
		3:
			localScore += 500
		4:
			localScore += 800
	
	return Vector2i(localScore, lines); #score and number of lines

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
	
	phantomHexomino = null;
	canHold = true;

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
			if isPositionValid(localHex):
				score += 1;
			$"../FXPlayer".stream = sfx_softDrop;
		if event.keycode == KEY_RIGHT:
			localHex.moveRight();
			$"../FXPlayer".stream = sfx_movement;
		if event.keycode == KEY_LEFT:
			localHex.moveLeft();
			$"../FXPlayer".stream = sfx_movement;
		if event.keycode == KEY_UP:
			localHex = tryRotationAntiClockwise();
			$"../FXPlayer".stream = sfx_rotation;
		if event.keycode == KEY_Z:
			localHex = tryRotationClockwise();
			$"../FXPlayer".stream = sfx_rotation;
		if event.keycode == KEY_C:
			localHex = tryHold();
		if event.keycode == KEY_SPACE:
			localHex = hardDrop();
			$"../FXPlayer".stream = sfx_hardDrop;
		
		if isPositionValid(localHex):
			undrawHexomino();
			currentHexomino = localHex;
			drawHexomino();
		else:
			$"../FXPlayer".stream = sfx_error;
		
		$"../FXPlayer".play()

func hardDrop() -> Hexomino:
	var localHex = hexomino.new(currentHexomino.position, currentHexomino.dir, currentHexomino.type, currentHexomino.texture);
	
	localHex.move(addDirections(Direction.BOTTOM, gridDirection));
	
	while (isPositionValid(localHex)):
		score += 2
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

func tryHold() -> Hexomino:
	var localHex;
	
	if(canHold && heldHexomino == -1):
		heldHexomino = currentHexomino.type;
		canHold = false;
		$"../FXPlayer".stream = sfx_hold;
		var type = getNextHexomino()
		localHex = hexomino.new(startingPosition, Direction.TOP, type, GetTextureFromType(type));
	else:
		if(heldHexomino != -1 && canHold):
			localHex = hexomino.new(startingPosition, Direction.TOP, heldHexomino, GetTextureFromType(heldHexomino));
			$"../CanvasLayer/VBoxContainer/Control/HoldLabel".texture = null;
			heldHexomino = currentHexomino.type;
			canHold = false;
			$"../FXPlayer".stream = sfx_unhold;
		else:
			localHex = null;
	
	match (heldHexomino):
			0:
				$"../CanvasLayer/VBoxContainer/Control/HoldLabel".texture = texture_Form_I;
			1:
				$"../CanvasLayer/VBoxContainer/Control/HoldLabel".texture = texture_Form_O;
			2:
				$"../CanvasLayer/VBoxContainer/Control/HoldLabel".texture = texture_Form_T;
			3:
				$"../CanvasLayer/VBoxContainer/Control/HoldLabel".texture = texture_Form_L;
			4:
				$"../CanvasLayer/VBoxContainer/Control/HoldLabel".texture = texture_Form_J;
			5:
				$"../CanvasLayer/VBoxContainer/Control/HoldLabel".texture = texture_Form_Z;
			6:
				$"../CanvasLayer/VBoxContainer/Control/HoldLabel".texture = texture_Form_S;
	
	return localHex;
