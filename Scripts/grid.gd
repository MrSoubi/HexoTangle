extends Node2D

const DETECTION_LENGTH: int = 5
const HEIGHT: int = 20
const WIDTH: int = 10

@onready var hexomino = $"../Hexomino"

var cell = load("res://Scenes/cell.tscn")

func _ready():
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

func is_position_available(position: Vector2) -> bool:
	var result = true
	
	# Define min/max for border checking
	var y_max = (HEIGHT - 1) * GlobalData.V_SPACING.y
	var x_max = (WIDTH / 2) * GlobalData.H_SPACING.x
	var x_min = - x_max
	
	for cell in get_children():
		var distance = abs((cell.global_position - position).length())
		result = result and distance > DETECTION_LENGTH and position.x <= x_max and position.x >= x_min and position.y <= y_max
		if (!result):
			break
	
	return result

func add_cell(cell: Cell):
	var temp_position = cell.global_position
	var temp_rotation = cell.global_rotation
	
	cell.get_parent().remove_child(cell)
	cell.name = "Cell_" + str(get_child_count())
	add_child(cell)
	cell.global_position = temp_position
	cell.global_rotation = temp_rotation
	# Check if a line has been done and trigger the coresponding signal

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
		if (cell.global_position.y < y_max and cell.global_position.x <= x_max and cell.global_position.x >= x_min): 
			
			# Get the line position, and adjustement if it's on an odd column
			var current_line = cell.global_position.y / GlobalData.V_SPACING.y
			if int(cell.global_position.x / GlobalData.H_SPACING.x) % 2 == 1:
				current_line -= 0.5
			
			lines[current_line].append(cell)
	
	# Send a signal !
	
	# Remove the cells that can be removed and move the others to the bottom
	var full_line_count = 0
	
	# Looping backwards on the array
	for i in range(lines.size() - 1, 0, -1):
		if (lines[i].size() == WIDTH + 1):
			full_line_count += 1
			$"../Camera2D".zoom_in()
			for cell in lines[i]:
				cell.position += Vector2(2000, 2000) # Replace this by something that removes the cells
		else:
			for cell in lines[i]:
				cell.position += GlobalData.V_SPACING * full_line_count # Replace this by something that moves the cells to the bottom with a nice effect
