extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@export var speed: float = 150.0
@export var thrown_object_scene: PackedScene  # asigna el ThrownObject.tscn en el inspector

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
var can_move_object = false  # Nueva variable para detectar si puede mover el objeto

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

	# -----------------------
	# Detectar si puede mover objeto
	# -----------------------
	check_object_proximity()

	# -----------------------
	# Cambiar color del sprite según si puede mover objeto
	# -----------------------
	if can_move_object:
		sprite.modulate = Color.RED
	else:
		sprite.modulate = Color.WHITE

	# -----------------------
	# Lanzar objeto
	# -----------------------
	if Input.is_action_just_pressed("ui_accept") and thrown_object_scene:
		launch_object(last_direction)

# Función para lanzar el objeto
func launch_object(direction: Vector2) -> void:
	var obj_instance = thrown_object_scene.instantiate()
	get_parent().add_child(obj_instance)
	obj_instance.global_position = global_position
	obj_instance.throw_object(direction)

# Nueva función para detectar si hay objeto cercano
func check_object_proximity():
	can_move_object = false
	for obj in get_parent().get_children():
		if obj.is_in_group("movable_object"):  # el objeto debe estar en este grupo
			if global_position.distance_to(obj.global_position) < 50:  # radio de detección
				can_move_object = true
				break
