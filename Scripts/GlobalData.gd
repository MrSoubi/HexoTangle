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
	ERROR}

enum Direction {TOP = 0, TOP_RIGHT = 1, BOTTOM_RIGHT = 2, BOTTOM = 3, BOTTOM_LEFT = 4, TOP_LEFT = 5}

enum HexType {I, O, T, L, J, Z, S};

enum State {FREE, BLOCKED, MOVING};

enum GameState {MENU, PLAYING, PAUSED};
var score: int
