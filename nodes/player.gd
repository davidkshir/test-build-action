class_name Player
extends Node

var id: int

@onready var health: HealthComponent = %Health

@onready var player_input: PlayerInput = %PlayerInput

@onready var tracking_delta: TrackingDeltaComponent = %TrackingDelta
