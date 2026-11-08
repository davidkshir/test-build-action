class_name GameManager
extends Node

@export var game_rules: GameRules

@onready var game_state: GameStateComponent = %GameState

@onready var round: RoundComponent = %Round
