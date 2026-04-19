class_name Runner
extends Node2D

var _running:bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enter_pose_1()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (_running):
		position.x += delta * 80

func enter_pose_1() -> void:
	$Sprite.play("startpose1")

func enter_pose_2() -> void:
	await get_tree().create_timer(randf_range(0.2, 0.6)).timeout
	$Sprite.play("startpose2")

func start_running() -> void:
	$Sprite.play("run")
	_running = true