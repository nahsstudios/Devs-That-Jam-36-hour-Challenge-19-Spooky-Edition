extends Node2D  # Funciona para Sprite2D, AnimatedSprite2D, CharacterBody2D, StaticBody2D, etc.

func _process(delta):
	z_index = int(position.y)
