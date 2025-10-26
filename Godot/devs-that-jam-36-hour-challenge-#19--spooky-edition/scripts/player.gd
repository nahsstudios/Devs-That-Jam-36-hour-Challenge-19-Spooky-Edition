extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@export var speed: float = 150.0

var move_animations = {
	Vector2.LEFT: ["walk_left", false],
	Vector2.RIGHT: ["walk_left", true],
	Vector2.UP: ["walk_up", false],
	Vector2.DOWN: ["walk_down", false],
	Vector2(-1, -1).normalized(): ["walk_up_left", false],
	Vector2(1, -1).normalized(): ["walk_up_left", true],
	Vector2(-1, 1).normalized(): ["walk_down_left", false],
	Vector2(1, 1).normalized(): ["walk_down_left", true]
}

var idle_animations = {
	Vector2.LEFT: ["idle_left", false],
	Vector2.RIGHT: ["idle_left", true],
	Vector2.UP: ["idle_up", false],
	Vector2.DOWN: ["idle_down", false],
	Vector2(-1, -1).normalized(): ["idle_up_left", false],
	Vector2(1, -1).normalized(): ["idle_up_left", true],
	Vector2(-1, 1).normalized(): ["idle_down_left", false],
	Vector2(1, 1).normalized(): ["idle_down_left", true]
}

var last_direction = Vector2.DOWN

func _physics_process(_delta: float) -> void:
	# -----------------------
	# Movimiento
	# -----------------------
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()
		velocity = input_vector * speed
		move_and_slide()

		last_direction = input_vector

		# Reproducir animación de movimiento
		for dir_vector in move_animations.keys():
			if input_vector.dot(dir_vector) > 0.9:
				sprite.play(move_animations[dir_vector][0])
				sprite.flip_h = move_animations[dir_vector][1]
				break
	else:
		velocity = Vector2.ZERO

		# Reproducir animación idle según última dirección
		for dir_vector in idle_animations.keys():
			if last_direction.dot(dir_vector) > 0.9:
				sprite.play(idle_animations[dir_vector][0])
				sprite.flip_h = idle_animations[dir_vector][1]
				break

	# -----------------------
	# Orden de dibujo según Y
	# -----------------------
	z_index = int(position.y)
