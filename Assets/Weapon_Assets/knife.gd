extends Node2D

@export var spin_speed = 5.0
@export var damage = 1

var weapon_owner

func _ready() -> void:
	weapon_owner = get_parent()

func _process(delta):
	rotation += spin_speed * delta
