extends Node2D

const DETECTION_LENGTH: int = 5;
const HEIGHT: int = 20;
const WIDTH: int = 10;

@onready var hexomino = $"../Hexomino"

var cell = load("res://Scenes/cell.tscn");

func _ready():
	# Left border
	for i in HEIGHT:
		var c = cell.instantiate();
		add_child(c);
		c.position = Vector2(-(WIDTH / 2 + 1) * GlobalData.H_SPACING.x, i * GlobalData.V_SPACING.y);
	
	# Right border
	for i in HEIGHT:
		var c = cell.instantiate();
		add_child(c);
		c.position = Vector2((WIDTH / 2 + 1) * GlobalData.H_SPACING.x, i * GlobalData.V_SPACING.y);
	
	# Bottom border
	for i in WIDTH + 1:
		var c = cell.instantiate();
		add_child(c);
		c.position = Vector2((i - WIDTH / 2) * GlobalData.H_SPACING.x, HEIGHT * GlobalData.V_SPACING.y - GlobalData.V_SPACING.y/2);
		if (i%2 == 1):
			c.position -= Vector2(0, GlobalData.V_SPACING.y / 2);

func is_position_available(position: Vector2) -> bool:
	var result = true;
	
	for cell in get_children():
		var distance = abs((cell.global_position - position).length());
		result = result and distance > DETECTION_LENGTH;
		if (!result):
			break;
	
	return result;

func add_cell(cell: Cell):
	var temp_position = cell.global_position;
	var temp_rotation = cell.global_rotation;
	
	cell.get_parent().remove_child(cell);
	cell.name = "Cell_" + str(get_child_count());
	add_child(cell);
	cell.global_position = temp_position;
	cell.global_rotation = temp_rotation;
	# Check if a line has been done and trigger the coresponding signal
