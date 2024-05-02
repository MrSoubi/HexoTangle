extends Node2D

@export var soundManager: Node

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

var cell = load("res://Cell.tscn");
var hexomino = load("res://Scripts/hexomino.gd");
var sepLine = load("res://separation_line.tscn");

var current_hexomino: Hexomino;
var current_hexomino_position: Vector2i;
var phantom_hexomino;
var held_hexomino = -1;


var grid = [];

var sepArray = []; # separation lines

var canHold: bool = true;

var score = 0;

var offsetX = -14.5
var offsetY = -18.4

signal figure_blocked(line_count : int, cell_count : int, is_hard_drop : bool);

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
		grid[row][0].setState(GlobalData.State.BLOCKED, GlobalData.textureBlocked)
		grid[row][GRID_WIDTH-1].setState(GlobalData.State.BLOCKED, GlobalData.textureBlocked)
	
	for col in range(GRID_WIDTH):
		grid[GRID_HEIGHT-1][col].setState(GlobalData.State.BLOCKED, GlobalData.textureBlocked)
	
	
	@warning_ignore("integer_division")
	#var type = getNextHexomino()
	#current_hexomino = hexomino.new(startingPosition, GlobalData.Direction.TOP, type, GlobalData.GetTextureFromType(type));

	
	draw_hexomino();

func get_occupied_cells_by_hexomino(position : Vector2i, hex : Hexomino) -> Array:
	var positions = [];
	
	positions.append(position);
	
	match hex.type:
		GlobalData.HexType.I:
			positions.append(get_neighbour(current_hexomino_position, GlobalData.add_directions(GlobalData.Direction.TOP_RIGHT, hex.dir)));
			positions.append(get_neighbour(current_hexomino_position, GlobalData.add_directions(GlobalData.Direction.BOTTOM_LEFT, hex.dir)));
			positions.append(get_neighbour(positions[2], GlobalData.add_directions(GlobalData.Direction.BOTTOM_LEFT, hex.dir)));
		GlobalData.HexType.O:
			positions.append(get_neighbour(current_hexomino_position, GlobalData.add_directions(GlobalData.Direction.BOTTOM, hex.dir)));
			positions.append(get_neighbour(current_hexomino_position, GlobalData.add_directions(GlobalData.Direction.BOTTOM_RIGHT, hex.dir)));
			positions.append(get_neighbour(positions[2], GlobalData.add_directions(GlobalData.Direction.BOTTOM, hex.dir)));
		GlobalData.HexType.T:
			positions.append(get_neighbour(current_hexomino_position, GlobalData.add_directions(GlobalData.Direction.TOP, hex.dir)));
			positions.append(get_neighbour(current_hexomino_position, GlobalData.add_directions(GlobalData.Direction.BOTTOM_LEFT, hex.dir)));
			positions.append(get_neighbour(positions[2], GlobalData.add_directions(GlobalData.Direction.BOTTOM_RIGHT, hex.dir)));
		GlobalData.HexType.L:
			positions.append(get_neighbour(current_hexomino_position, GlobalData.add_directions(GlobalData.Direction.TOP_LEFT, hex.dir)));
			positions.append(get_neighbour(current_hexomino_position, GlobalData.add_directions(GlobalData.Direction.BOTTOM_RIGHT, hex.dir)));
			positions.append(get_neighbour(positions[2], GlobalData.add_directions(GlobalData.Direction.TOP_RIGHT, hex.dir)));
		GlobalData.HexType.J:
			positions.append(get_neighbour(current_hexomino_position, GlobalData.add_directions(GlobalData.Direction.TOP_RIGHT, hex.dir)));
			positions.append(get_neighbour(current_hexomino_position, GlobalData.add_directions(GlobalData.Direction.BOTTOM_LEFT, hex.dir)));
			positions.append(get_neighbour(positions[2], GlobalData.add_directions(GlobalData.Direction.TOP_LEFT, hex.dir)));
		GlobalData.HexType.Z:
			positions.append(get_neighbour(current_hexomino_position, GlobalData.add_directions(GlobalData.Direction.TOP, hex.dir)));
			positions.append(get_neighbour(current_hexomino_position, GlobalData.add_directions(GlobalData.Direction.BOTTOM_LEFT, hex.dir)));
			positions.append(get_neighbour(positions[2], GlobalData.add_directions(GlobalData.Direction.TOP_LEFT, hex.dir)));
		GlobalData.HexType.S:
			positions.append(get_neighbour(current_hexomino_position, GlobalData.add_directions(GlobalData.Direction.TOP, hex.dir)));
			positions.append(get_neighbour(current_hexomino_position, GlobalData.add_directions(GlobalData.Direction.BOTTOM_RIGHT, hex.dir)));
			positions.append(get_neighbour(positions[2], GlobalData.add_directions(GlobalData.Direction.BOTTOM, hex.dir)));
	
	return positions;

func reset():
	canHold = true;
	held_hexomino = -1;
	$"../UI/VBoxContainer/Control/HoldLabel".texture = null;
	
	#nextQueue = []; #stocks GlobalData.HexTypes

	
	score = 0;
	
	#var type = getNextHexomino()
	#current_hexomino = hexomino.new(startingPosition, GlobalData.Direction.TOP, type, GlobalData.GetTextureFromType(type));
	
	for n in range(GRID_HEIGHT):
		for m in range(GRID_WIDTH):
			grid[n][m].setState(GlobalData.State.FREE, GlobalData.textureFree)
	
	for row in range(GRID_HEIGHT):
		grid[row][0].setState(GlobalData.State.BLOCKED, GlobalData.textureBlocked)
		grid[row][GRID_WIDTH-1].setState(GlobalData.State.BLOCKED, GlobalData.textureBlocked)
	
	for col in range(GRID_WIDTH):
		grid[GRID_HEIGHT-1][col].setState(GlobalData.State.BLOCKED, GlobalData.textureBlocked)



func draw_phantom():
	var localHex = hexomino.new(current_hexomino.position, current_hexomino.dir, current_hexomino.type, current_hexomino.texture);
	
	localHex.move(GlobalData.add_directions(GlobalData.Direction.BOTTOM, 0));
	
	while (is_position_valid(localHex)):
		localHex.move(GlobalData.add_directions(GlobalData.Direction.BOTTOM, 0));
	
	localHex.move(GlobalData.add_directions(GlobalData.Direction.TOP, 0))
	
	phantom_hexomino = localHex;
	
	var localPositions = phantom_hexomino.getPositions();
	
	for i in range(4):
		var localCell = localPositions[i]
		grid[localCell.x][localCell.y].setState(GlobalData.State.FREE, GlobalData.texturePhantom)

func undraw_phantom():
	if (phantom_hexomino != null):
		var localPositions = phantom_hexomino.getPositions();
			
		for i in range(4):
			var localCell = localPositions[i]
			grid[localCell.x][localCell.y].setState(GlobalData.State.FREE, GlobalData.textureFree)

func draw_hexomino():
	draw_phantom();
	var localPositions = current_hexomino.getPositions();
	
	for i in range(4):
		var localCell = localPositions[i]
		grid[localCell.x][localCell.y].setState(GlobalData.State.MOVING, current_hexomino.texture)

func undraw_hexomino():
	undraw_phantom();
	var localPositions = current_hexomino.getPositions();
	
	for i in range(4):
		var localCell = localPositions[i]
		grid[localCell.x][localCell.y].setState(GlobalData.State.FREE, GlobalData.textureFree)

func is_inverse_line_full(row: int) -> bool:
	var result: bool = true;
	
	for i in range(GRID_WIDTH):
		if i%2 == 0:
			result = result && !grid[row][i].isEmpty();
		else:
			result = result && !grid[row-1][i].isEmpty();
	
	return result;
	
func is_line_full(row: int) -> bool:
	var result: bool = true;
	
	for i in range(GRID_WIDTH):
		result = result && !grid[row][i].isEmpty();
	
	return result;

func get_full_lines() -> Array:
	var result = [];
	
	for i in range(GRID_HEIGHT):
		if (is_line_full(i) && i != GRID_HEIGHT-1):
			result.append(i);
	
	return result;

func get_full_inverse_lines() -> Array:
	var result = [];
	
	for i in range(GRID_HEIGHT):
		if (is_inverse_line_full(i) && i != GRID_HEIGHT-1):
			result.append(i);
	
	return result;
	
func handle_full_lines():
	var fullLines = get_full_lines();
	
	for row in fullLines:
		remove_line(row);
	
	#fullLines = get_full_inverse_lines();
	
	for row in fullLines:
		#remove_inverse_line(row);
		pass
	
	return fullLines.size();

func remove_line(row: int):
	if (row == 0):
		for col in range(1, GRID_WIDTH-1):
			grid[row][col].setState(GlobalData.State.FREE, GlobalData.textureFree);
	else:
		for col in range(1, GRID_WIDTH-1):
			grid[row][col].setState(grid[row-1][col].state, grid[row-1][col].get_node("Sprite2D").texture);
		remove_line(row-1)

func remove_inverse_line(row: int):
	if (row == 0):
		for col in range(1, GRID_WIDTH-1):
			grid[row][col].setState(GlobalData.State.FREE, GlobalData.textureFree);
	else:
		for col in range(1, GRID_WIDTH-1):
			grid[row][col].setState(grid[row-1][col].state, grid[row-1][col].get_node("Sprite2D").texture);
		remove_line(row-1)
		
func is_position_valid(hex: Hexomino) -> bool:
	var result;
	
	if (hex != null):
		var positions = hex.getPositions()
		result = true;
		
		for i in range(4):
			var localX = positions[i].x
			var localY = positions[i].y
			if (localX < grid.size() && localY < grid[0].size()):
				result = result && grid[localX][localY].state != GlobalData.State.BLOCKED
			else:
				result = false;
	else:
		result = false;
	
	return result;


func try_spawn_hexomino(hex: Hexomino) -> bool:
	current_hexomino = hex;
	draw_hexomino();
	
	return true;

func get_neighbour(position: Vector2, direction: GlobalData.Direction) -> Vector2:
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

func block_hexomino():
	var localPositions = current_hexomino.getPositions();
	
	for i in range(4):
		var localCell = localPositions[i]
		grid[localCell.x][localCell.y].setState(GlobalData.State.BLOCKED, current_hexomino.texture)
	
	phantom_hexomino = null;
	canHold = true;


func try_move_left(hex: Hexomino) -> bool:
	var localHex = hexomino.new(hex.position, hex.dir, current_hexomino.type, hex.texture);
	
	if int(localHex.position.y) % 2 == 0:
		localHex.move(GlobalData.Direction.BOTTOM_LEFT);
		if (not is_position_valid(localHex)):
			localHex = hexomino.new(hex.position, hex.dir, current_hexomino.type, hex.texture);
			localHex.move(GlobalData.Direction.TOP_LEFT);
	else:
		localHex.move(GlobalData.Direction.TOP_LEFT);
		if (not is_position_valid(localHex)):
			localHex = hexomino.new(hex.position, hex.dir, current_hexomino.type, hex.texture);
			localHex.move(GlobalData.Direction.BOTTOM_LEFT);
	
	return true;

func try_move_right(hex: Hexomino) -> bool:
	var localHex = hexomino.new(hex.position, hex.dir, current_hexomino.type, hex.texture);
	
	if int(localHex.position.y) % 2 == 0:
		localHex.move(GlobalData.Direction.BOTTOM_RIGHT);
		if (not is_position_valid(localHex)):
			localHex = hexomino.new(hex.position, hex.dir, current_hexomino.type, hex.texture);
			localHex.move(GlobalData.Direction.TOP_RIGHT);
	else:
		localHex.move(GlobalData.Direction.TOP_RIGHT);
		if (not is_position_valid(localHex)):
			localHex = hexomino.new(hex.position, hex.dir, current_hexomino.type, hex.texture);
			localHex.move(GlobalData.Direction.BOTTOM_RIGHT);
	
	return localHex;

func try_soft_drop() -> bool:
	return true;

func try_hard_drop() -> bool:
	var localHex = hexomino.new(current_hexomino.position, current_hexomino.dir, current_hexomino.type, current_hexomino.texture);
	
	localHex.move(GlobalData.add_directions(GlobalData.Direction.BOTTOM, 0));
	
	while (is_position_valid(localHex)):
		score += 2
		localHex.move(GlobalData.add_directions(GlobalData.Direction.BOTTOM, 0));
	
	localHex.move(GlobalData.add_directions(GlobalData.Direction.TOP, 0))
	
	return true;

func try_rotate_anti_clockwise() -> bool:
	var localHex = hexomino.new(current_hexomino.position, current_hexomino.dir, current_hexomino.type, current_hexomino.texture);
	var baseHex = hexomino.new(current_hexomino.position, current_hexomino.dir, current_hexomino.type, current_hexomino.texture);
	
	localHex.rotateAntiClockwise();
	
	if (!is_position_valid(localHex)):
		localHex.move(GlobalData.add_directions(GlobalData.Direction.TOP_LEFT, 0));
	
		if (!is_position_valid(localHex)):
			localHex = baseHex;
			localHex.rotate_anti_clockwise();
			localHex.move(GlobalData.add_directions(GlobalData.Direction.TOP_RIGHT, 0));
		
			if (!is_position_valid(localHex)):
				localHex = baseHex;
				localHex.rotate_anti_clockwise();
				localHex.move(GlobalData.add_directions(GlobalData.Direction.TOP, 0));
	
	return true;

func try_rotate_clockwise() -> bool:
	var localHex = hexomino.new(current_hexomino.position, current_hexomino.dir, current_hexomino.type, current_hexomino.texture);
	var baseHex = hexomino.new(current_hexomino.position, current_hexomino.dir, current_hexomino.type, current_hexomino.texture);
	
	localHex.rotateClockwise();
	
	if (!is_position_valid(localHex)):
		localHex.move(GlobalData.add_directions(GlobalData.Direction.TOP_RIGHT, 0));
	
		if (!is_position_valid(localHex)):
			localHex = baseHex;
			localHex.rotate_clockwise();
			localHex.move(GlobalData.add_directions(GlobalData.Direction.TOP_LEFT, 0));
		
			if (!is_position_valid(localHex)):
				localHex = baseHex;
				localHex.rotate_clockwise();
				localHex.move(GlobalData.add_directions(GlobalData.Direction.TOP, 0));
	
	return true;
