class_name GameRecord
extends Resource

enum WinStates {
	STATE_NONE,

	STATE_DRAW,

	STATE_WIN,
}

var loser_id: int = -1

var win_state: WinStates = WinStates.STATE_NONE

var winner_id: int = -1
