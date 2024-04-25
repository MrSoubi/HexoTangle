@tool extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	if Engine.is_editor_hint():
		position = get_viewport().size / 2
		print(position)
