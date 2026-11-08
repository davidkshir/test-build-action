class_name Player
extends Node

var id: int

@onready var health: HealthComponent = %Health

@onready var is_ready: IsReadyComponent = %IsReady

@onready var score: ScoreComponent = %Score


func _init(_id: int):
	id = _id
