class_name GameScene
extends Node2D


var runners:Array

func _ready() -> void:
	runners = [$Runner]

func start_running() -> void:
	$Runner.start_running()