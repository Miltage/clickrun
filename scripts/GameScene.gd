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

	$Runner1.run_complete.connect(_on_runner_run_complete.bind(0))
	$Runner2.run_complete.connect(_on_runner_run_complete.bind(1))
	$Runner3.run_complete.connect(_on_runner_run_complete.bind(2))
	$Runner4.run_complete.connect(_on_runner_run_complete.bind(3))
	$Runner5.run_complete.connect(_on_runner_run_complete.bind(4))

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

	for child in %RunnerInfo.get_children():
		child.make_hidden()

	for runner in runners:
		runner.auto_run()

	await get_tree().create_timer(randf_range(1.0, 2.0)).timeout
	$PistolGuy.return_to_idle()

func setup_race(raceData:Array, playerPos:int) -> void:
	for i in runners.size():
		runners[i].visible = i < raceData.size()
		runners[i].set_color_from_country(raceData[i].country)
		if (i < raceData.size()):
			if (raceData[i].has('reaction_us')): 
				runners[i].reactionTime = raceData[i].reaction_us
	
	playerRunner = runners[playerPos]
	playerRunner.visible = true

	set_player_info(raceData)

func update_player_time(playerPos:int, usec:int) -> void:
	var playerInfo:PlayerInfo = %RunnerInfo.get_child(playerPos)
	playerInfo.set_time(usec)
	playerInfo.show_time()

func _on_runner_start(_pos: int) -> void:
	return

func _on_runner_run_complete(pos: int) -> void:
	var playerInfo:PlayerInfo = %RunnerInfo.get_child(pos)
	playerInfo.make_visible()
	playerInfo.show_time()

func set_player_info(raceData:Array) -> void:
	for i in %RunnerInfo.get_child_count():
		var playerInfo:PlayerInfo = %RunnerInfo.get_child(i)
		playerInfo.visible = i < raceData.size()
		if (i < raceData.size()):
			playerInfo.set_country(raceData[i].country)
			playerInfo.set_player_name(raceData[i].player_name)
			playerInfo.set_time(raceData[i].reaction_us if (raceData[i].has('reaction_us')) else 0)
			playerInfo.hide_time()
			playerInfo.set_highlighted(i == Main.playerPos)

func false_start(playerPos:int) -> void:
	playerRunner.start_running()
	%RunnerInfo.get_child(playerPos).make_hidden()
	$FalseStart.play()