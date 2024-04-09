class_name Cell extends Node2D

@export var sprite: Sprite2D;

var state: GlobalData.State = GlobalData.State.FREE;

const SCALE = Vector2(0.3, 0.3);

var textureFree: Texture2D = load("res://Sprites/Hex_Empty.png");
var textureBlocked: Texture2D = load("res://Sprites/Hex_Black.png");
var textureMoving: Texture2D = load("res://Sprites/Hexagon_Blue.png");

var texture_O: Texture2D = load("res://Sprites/Hex_Yellow.png")
var texture_I: Texture2D = load("res://Sprites/Hex_Blue.png")
var texture_T: Texture2D = load("res://Sprites/Hex_Purple.png")
var texture_L: Texture2D = load("res://Sprites/Hex_Orange.png")
var texture_J: Texture2D = load("res://Sprites/Hex_DarkBlue.png")
var texture_S: Texture2D = load("res://Sprites/Hex_Green.png")
var texture_Z: Texture2D = load("res://Sprites/Hex_Red.png")

var texture: Texture2D;

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.texture = textureFree;
	apply_scale(SCALE);

func isEmpty() -> bool:
	return state == GlobalData.State.FREE;

func setState(newState: GlobalData.State, texture: Texture2D):
	state = newState;
	sprite.texture = texture;
