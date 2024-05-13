extends Node

enum SFX {
	ONE_LINE,
	TWO_LINES,
	THREE_LINES,
	FOUR_LINES,
	HARD_DROP,
	SOFT_DROP,
	ROTATION,
	MOVEMENT,
	HOLD,
	ERROR
	}

enum Direction {TOP = 0, TOP_RIGHT = 1, BOTTOM_RIGHT = 2, BOTTOM = 3, BOTTOM_LEFT = 4, TOP_LEFT = 5}

enum HexType {I, O, T, L, J, Z, S};

enum State {FREE, BLOCKED, MOVING};

enum GameState {MENU, PLAYING, PAUSED};

var textureFree: Texture2D = load("res://Sprites/Hex_Empty.png");
var textureBlocked: Texture2D = load("res://Sprites/Hex_Black.png");
var texturePhantom : Texture2D = load("res://Sprites/Hex_Phantom.png")

var texture_O: Texture2D = load("res://Sprites/Hex_Yellow.png")
var texture_I: Texture2D = load("res://Sprites/Hex_Blue.png")
var texture_T: Texture2D = load("res://Sprites/Hex_Purple.png")
var texture_L: Texture2D = load("res://Sprites/Hex_Orange.png")
var texture_J: Texture2D = load("res://Sprites/Hex_DarkBlue.png")
var texture_S: Texture2D = load("res://Sprites/Hex_Green.png")
var texture_Z: Texture2D = load("res://Sprites/Hex_Red.png")

var texture_Form_O: Texture2D = load("res://Sprites/Form_O.png")
var texture_Form_I: Texture2D = load("res://Sprites/Form_I.png")
var texture_Form_T: Texture2D = load("res://Sprites/Form_T.png")
var texture_Form_L: Texture2D = load("res://Sprites/Form_L.png")
var texture_Form_J: Texture2D = load("res://Sprites/Form_J.png")
var texture_Form_S: Texture2D = load("res://Sprites/Form_S.png")
var texture_Form_Z: Texture2D = load("res://Sprites/Form_Z.png")

func get_texture_from_type(type: GlobalData.HexType) -> Texture2D:
	var result: Texture2D;
	
	match(type):
		GlobalData.HexType.I:
			result = texture_I;
		GlobalData.HexType.O:
			result = texture_O;
		GlobalData.HexType.T:
			result = texture_T;
		GlobalData.HexType.L:
			result = texture_L;
		GlobalData.HexType.J:
			result = texture_J;
		GlobalData.HexType.Z:
			result = texture_Z;
		GlobalData.HexType.S:
			result = texture_S;
		
	return result;

func add_directions(dir1: GlobalData.Direction, dir2: GlobalData.Direction) -> GlobalData.Direction:
	var val1 = int(dir1);
	var val2 = int(dir2);
	
	var result: GlobalData.Direction;
	
	match (val1 + val2) % 6:
		0:
			result = GlobalData.Direction.TOP
		1:
			result = GlobalData.Direction.TOP_RIGHT
		2:
			result = GlobalData.Direction.BOTTOM_RIGHT
		3:
			result = GlobalData.Direction.BOTTOM
		4:
			result = GlobalData.Direction.BOTTOM_LEFT
		5:
			result = GlobalData.Direction.TOP_LEFT
	
	return result;

const V_SPACING = Vector2(0, 108);
const H_SPACING = Vector2(94, 0);
