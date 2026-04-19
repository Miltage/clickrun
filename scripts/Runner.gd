class_name Runner
extends Node2D

signal start

var reactionTime:int

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

func auto_run() -> void:
	if (reactionTime == 0): return
	await get_tree().create_timer(reactionTime / 1_000_000.0).timeout
	start_running()

func start_running() -> void:	
	$Sprite.play("run")
	_running = true
	start.emit()