class_name GameScene
extends Node2D

var runners:Array
var playerRunner:Runner

func _ready() -> void:
	runners = [$Runner1, $Runner2, $Runner3, $Runner4, $Runner5]

	for runner in runners:
		runner.hide()
	
	for child in %RunnerInfo.get_children():
		child.hide()

	$Runner1.start.connect(_on_runner_start.bind(0))
	$Runner2.start.connect(_on_runner_start.bind(1))
	$Runner3.start.connect(_on_runner_start.bind(2))
	$Runner4.start.connect(_on_runner_start.bind(3))
	$Runner5.start.connect(_on_runner_start.bind(4))

func start_running() -> void:
	playerRunner.start_running()

func on_your_marks() -> void:
	$OnYourMarks.play()

func prepare_runners() -> void:
	$Set.play()
	$PistolGuy.prepare_to_fire()
	for runner in runners:
		runner.enter_pose_2()

func pistol_fire() -> void:
	$PistolShot.play()
	$PistolGuy.fire()

	for runner in runners:
		runner.auto_run()

	await get_tree().create_timer(randf_range(1.0, 2.0)).timeout
	$PistolGuy.return_to_idle()

func setup_race(raceData:Array, playerPos:int) -> void:
	for i in runners.size():
		runners[i].visible = i < raceData.size()
		if (i < raceData.size()):
			if (raceData[i].has('reaction_us')): 
				runners[i].reactionTime = raceData[i].reaction_us
	
	playerRunner = runners[playerPos]
	playerRunner.visible = true

	set_player_info(raceData)

func _on_runner_start(pos: int) -> void:
	%RunnerInfo.get_child(pos).modulate = Color.TRANSPARENT

func set_player_info(raceData:Array) -> void:
	for i in %RunnerInfo.get_child_count():
		var playerInfo:PlayerInfo = %RunnerInfo.get_child(i)
		playerInfo.visible = i < raceData.size()
		if (i < raceData.size()):
			playerInfo.set_country(raceData[i].country)
			playerInfo.set_player_name(raceData[i].player_name)