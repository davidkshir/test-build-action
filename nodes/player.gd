class_name Player
extends Node

var id: int

@onready var health: HealthComponent = %Health

@onready var player_input: PlayerInput = %PlayerInput

@onready var is_ready: IsReadyComponent = %IsReady

@onready var score: ScoreComponent = %Score

@onready var tracking_delta: TrackingDeltaComponent = %TrackingDelta
