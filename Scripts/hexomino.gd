class_name Hexomino extends Node2D

@onready var cell_1 = $Cell_1
@onready var cell_2 = $Cell_2
@onready var cell_3 = $Cell_3
@onready var cell_4 = $Cell_4

@onready var grid = $"../Grid"

var cell = load("res://Scenes/cell.tscn")
var hexomino = load("res://Scenes/hexomino.tscn")

var type: GlobalData.HexType

func set_type(type: GlobalData.HexType):
	self.type = type
	
	match type:
		GlobalData.HexType.I:
			cell_1.position = position
			cell_2.position = position + GlobalData.V_SPACING # bottom
			cell_3.position = position + GlobalData.V_SPACING * 2 # bottom twice
			cell_4.position = position - GlobalData.V_SPACING # top
		GlobalData.HexType.O:
			cell_1.position = position
			cell_2.position = position + GlobalData.V_SPACING # bottom
			cell_3.position = position - (GlobalData.V_SPACING / 2) + GlobalData.H_SPACING # top right
			cell_4.position = position + (GlobalData.V_SPACING / 2) + GlobalData.H_SPACING # bottom right
		GlobalData.HexType.T:
			cell_1.position = position
			cell_2.position = position + GlobalData.V_SPACING
			cell_3.position = position + GlobalData.V_SPACING * 2
			cell_4.position = position - GlobalData.V_SPACING
		GlobalData.HexType.L:
			cell_1.position = position
			cell_2.position = position + GlobalData.V_SPACING
			cell_3.position = position + GlobalData.V_SPACING * 2
			cell_4.position = position - GlobalData.V_SPACING
		GlobalData.HexType.J:
			cell_1.position = position
			cell_2.position = position + GlobalData.V_SPACING
			cell_3.position = position + GlobalData.V_SPACING * 2
			cell_4.position = position - GlobalData.V_SPACING
		GlobalData.HexType.Z:
			cell_1.position = position
			cell_2.position = position + GlobalData.V_SPACING
			cell_3.position = position + GlobalData.V_SPACING * 2
			cell_4.position = position - GlobalData.V_SPACING
		GlobalData.HexType.S:
			cell_1.position = position
			cell_2.position = position + GlobalData.V_SPACING
			cell_3.position = position + GlobalData.V_SPACING * 2
			cell_4.position = position - GlobalData.V_SPACING

func _ready():
	set_type(GlobalData.HexType.O)

func rotate_clockwise():
	rotate(deg_to_rad(-60))

func rotate_anti_clockwise():
	rotate(deg_to_rad(60))

func move_to(position: Vector2):
	self.position = position
	cell_1.update_label()
	cell_2.update_label()
	cell_3.update_label()
	cell_4.update_label()


signal hexomino_has_blocked

func block():
	# The figure gives its cells to the grid stack
	grid.add_cell(cell_1)
	grid.add_cell(cell_2)
	grid.add_cell(cell_3)
	grid.add_cell(cell_4)
	
	# The figure moves back to the top of the screen
	self.position = Vector2(0,0)
	self.rotation = 0
	
	# The figure generates a new set of cells
	cell_1 = cell.instantiate()
	cell_2 = cell.instantiate()
	cell_3 = cell.instantiate()
	cell_4 = cell.instantiate()
	
	cell_1.name = "Cell_1"
	cell_2.name = "Cell_2"
	cell_3.name = "Cell_3"
	cell_4.name = "Cell_4"
	
	add_child(cell_1)
	add_child(cell_2)
	add_child(cell_3)
	add_child(cell_4)
	
	hexomino_has_blocked.emit();
