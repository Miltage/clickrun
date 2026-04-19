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

	var type:int = randi_range(1, 3)
	$Sprite.visible = type == 1
	$Sprite2.visible = type == 2
	$Sprite3.visible = type == 3

func _process(delta: float) -> void:
	if (_running):
		position.x += delta * _speed
		_speed = lerp(_speed, MAX_SPEED, 0.1)

		if (position.x > 20 && !_complete):
			run_complete.emit()
			_complete = true

func enter_pose_1() -> void:
	$Sprite.play("startpose1")
	$Sprite2.play("startpose1")
	$Sprite3.play("startpose1")

func enter_pose_2() -> void:
	await get_tree().create_timer(randf_range(0.2, 0.6)).timeout
	$Sprite.play("startpose2")
	$Sprite2.play("startpose2")
	$Sprite3.play("startpose2")

func auto_run() -> void:
	if (reactionTime == 0): return
	await get_tree().create_timer(reactionTime / 1_000_000.0).timeout
	start_running()

func start_running() -> void:	
	$Sprite.play("run")
	$Sprite2.play("run")
	$Sprite3.play("run")
	_running = true
	start.emit()

func set_color_from_country(country:String) -> void:
	var tex:Texture2D = load("res://textures/flags/%s.png" % country)
	var color:Color = Global.get_most_prominent_color(tex)
	$Sprite.material.set_shader_parameter("target_color", color)
	$Sprite2.material.set_shader_parameter("target_color", color)
	$Sprite3.material.set_shader_parameter("target_color", color)