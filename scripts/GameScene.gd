class_name GameScene
extends Node2D

var runners:Array

func _ready() -> void:
	runners = [$Runner, $Runner2, $Runner3, $Runner4, $Runner5]

func start_running() -> void:
	$Runner.start_running()

func on_your_marks() -> void:
	$OnYourMarks.play()

func set_race() -> void:
	$Set.play()
	$PistolGuy.prepare_to_fire()
	for runner in runners:
		runner.enter_pose_2()

func pistol_fire() -> void:
	$PistolShot.play()
	$PistolGuy.fire()

	await get_tree().create_timer(randf_range(1.0, 2.0)).timeout
	$PistolGuy.return_to_idle()