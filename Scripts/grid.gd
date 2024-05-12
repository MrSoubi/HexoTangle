extends Node2D

const DETECTION_LENGTH: int = 2
const HEIGHT: int = 20
const WIDTH: int = 10

@onready var hexomino = $"../Hexomino"

var cell = load("res://Scenes/cell.tscn")

func _ready():
	reset()

func reset():
	for n in get_children():
		n.free()
	
	# Left border
	for i in HEIGHT:
		var c = cell.instantiate()
		add_child(c)
		c.position = Vector2(-(WIDTH / 2 + 1) * GlobalData.H_SPACING.x, i * GlobalData.V_SPACING.y)
	
	# Right border
	for i in HEIGHT:
		var c = cell.instantiate()
		add_child(c)
		c.position = Vector2((WIDTH / 2 + 1) * GlobalData.H_SPACING.x, i * GlobalData.V_SPACING.y)
	
	# Bottom border
	for i in WIDTH + 1:
		var c = cell.instantiate()
		add_child(c)
		c.position = Vector2((i - WIDTH / 2) * GlobalData.H_SPACING.x, HEIGHT * GlobalData.V_SPACING.y - GlobalData.V_SPACING.y/2)
		if (i%2 == 1):
			c.position -= Vector2(0, GlobalData.V_SPACING.y / 2)

func is_hexomino_in_valid_position(hex: Hexomino) -> bool:
	var result = (is_position_available(hex.cell_2.global_position) and
				is_position_available(hex.cell_3.global_position) and
				is_position_available(hex.cell_4.global_position) and
				is_position_available(hex.cell_1.global_position))
	
	return result

func is_position_available(position: Vector2) -> bool:
	var result = true
	
	# Define min/max for border checking
	var y_max = (HEIGHT - 1) * GlobalData.V_SPACING.y
	var x_max = (WIDTH / 2) * GlobalData.H_SPACING.x
	var x_min = - x_max
	
	for cell in get_children():
		var distance = abs((cell.global_position - position).length())
		result = (result # Do not continue if one cell is already on a bad place
			and distance > DETECTION_LENGTH # Check if the cell is on top of another
			)
		if (!result):
			break
	
	return result

func add_cell(cell: Cell):
	var temp_position = cell.global_position
	
	cell.get_parent().remove_child(cell)
	cell.name = "Cell_" + str(get_child_count())
	add_child(cell)
	cell.global_position = Vector2(snapped(temp_position.x, 1), snapped(temp_position.y, 1))

signal lines_completed(count: int)

func handle_full_lines():
	var lines = []
	
	for i in HEIGHT:
		lines.append([])
	
	# Define min/max for border checking
	var y_max = (HEIGHT - 1) * GlobalData.V_SPACING.y
	var x_max = (WIDTH / 2) * GlobalData.H_SPACING.x
	var x_min = - x_max
	
	for cell in get_children():
		# Check if the current cell is not a border cell
		if (cell.global_position.y < y_max
		and cell.global_position.x <= x_max
		and cell.global_position.x >= x_min): 
			
			var local_y = snappedf(cell.global_position.y, GlobalData.V_SPACING.y / 2)
			var current_line = local_y / GlobalData.V_SPACING.y
			var decimal_part = current_line - floor(current_line)
			if (decimal_part != 0):
				current_line -= 0.5
			
			lines[current_line].append(cell)
	
	# Remove the cells that can be removed and move the others to the bottom
	var full_line_count = 0
	
	# Looping backwards on the array
	for i in range(lines.size() - 1, 0, -1):
		if (lines[i].size() == WIDTH + 1):
			full_line_count += 1
			$"../Camera2D".zoom_in()
			for cell in lines[i]:
				cell.animate_destruction()
		else:
			for cell in lines[i]:
				cell.position += GlobalData.V_SPACING * full_line_count # Replace this by something that moves the cells to the bottom with a nice effect
	
	lines_completed.emit(full_line_count)
