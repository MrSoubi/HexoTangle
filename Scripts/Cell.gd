extends Node2D

var state: GlobalData.State = GlobalData.State.FREE;

func is_empty() -> bool:
	return state == GlobalData.State.FREE;

func set_state(new_state: GlobalData.State, texture: Texture2D):
	state = new_state;

func move_to(position: Vector2i):
	self.position = position;
