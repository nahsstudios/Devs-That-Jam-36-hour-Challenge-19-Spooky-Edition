extends StaticBody2D

@onready var anim = $AnimatedSprite2D
@export var y_offset: int = 0  # Ajuste opcional para dibujarse un poco delante o detrás del jugador

func _ready():
	# Reproduce la animación de reposo
	if anim:
		anim.play("default")

@warning_ignore("unused_parameter")
func _process(delta):
	# Actualiza el z_index según la posición Y del nodo principal
	# Esto asegura que el auto se dibuje delante o detrás del jugador
	z_index = int(global_position.y) + y_offset
