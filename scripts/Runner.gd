class_name Runner
extends Node2D

const START_SPEED:float = 20
const MAX_SPEED:float = 100

signal start
signal run_complete

var reactionTime:int

var _running:bool
var _speed:float
var _complete:bool

func _ready() -> void:
	enter_pose_1()
	_speed = START_SPEED

func _process(delta: float) -> void:
	if (_running):
		position.x += delta * _speed
		_speed = lerp(_speed, MAX_SPEED, 0.1)

		if (position.x > 20 && !_complete):
			run_complete.emit()
			_complete = true

func enter_pose_1() -> void:
	$Sprite.play("startpose1")

func enter_pose_2() -> void:
	await get_tree().create_timer(randf_range(0.2, 0.6)).timeout
	$Sprite.play("startpose2")

func auto_run() -> void:
	if (reactionTime == 0): return
	await get_tree().create_timer(reactionTime / 1_000_000.0).timeout
	start_running()

func start_running() -> void:	
	$Sprite.play("run")
	_running = true
	start.emit()

func set_color(color:Color) -> void:
	$Sprite.material.set_shader_parameter("target_color", color)