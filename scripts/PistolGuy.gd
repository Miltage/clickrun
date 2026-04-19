class_name PistolGuy
extends Node2D

func _ready() -> void:
	$Sprite.play("idle")

func prepare_to_fire() -> void:
	$Sprite.play("prepare")

func fire() -> void:
	$Sprite.play("fire")

func return_to_idle() -> void:
	$Sprite.play("idle")