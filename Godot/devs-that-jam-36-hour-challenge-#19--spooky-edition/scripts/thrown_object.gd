extends RigidBody2D

@onready var sprite = $ObjectSprite
@onready var shadow = $Shadow

@export var max_height: float = 100
@export var throw_speed: float = 300

var height = 0.0
var is_airborne = false

func throw_object(direction: Vector2) -> void:
	# Aplicar impulso para lanzarlo
	apply_central_impulse(direction.normalized() * throw_speed)
	height = max_height
	is_airborne = true

func _process(delta: float) -> void:
	# Simula la altura del objeto (solo visual)
	if is_airborne:
		height -= 300 * delta
		if height < 0:
			height = 0
			is_airborne = false
	
	# Eleva el sprite visualmente
	if sprite:
		sprite.position = Vector2(0, -height)
	
	# Ajusta la sombra
	if shadow:
		var scale_val = lerp(1.2, 0.5, height / max_height)
		shadow.scale = Vector2(scale_val, scale_val)
