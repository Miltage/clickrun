class_name Main
extends Control

const SAVE_PATH = "user://save.cfg"

static var playerCountry:String
static var playerName:String
static var playerTime:int
static var playerPos:int
static var bestTime:int

var raceData:Array = []
var fireTime:int = 0
var pistolFired:bool = false
var raceSet:bool = false

func _ready() -> void:
	%RetryButton.hide()
	%PlayerInfo.hide()
	%LeaderboardsButton.hide()
	%SubmitScoreButton.hide()
	%StartButton.show()
	%Label.text = ""
	%DeleteDataButton.visible = OS.has_feature("editor")

	_load_progress()

	_update_ui()

func _update_ui() -> void:
	if (!playerCountry):
		playerCountry = Global.pick_random_country()
		%CountrySelector.show()
	else:
		_update_country()
		%PlayerInfo.show()
		%LeaderboardsButton.show()
		setup_race()

	if (playerName):
		%PlayerInfo.set_player_name(playerName)

	print(bestTime)
	
	if (bestTime > 0 && bestTime < 1000000):
		%PlayerInfo.set_time(bestTime)
		%PlayerInfo.show_time()
	else:
		bestTime = 100000000

func _load_progress() -> void:
	var cfg := ConfigFile.new()
	if (cfg.load(SAVE_PATH) != OK):
		return
	playerCountry = cfg.get_value("player", "country", "")
	playerName = cfg.get_value("player", "name", "")
	playerTime = cfg.get_value("player", "time", 0)
	bestTime = cfg.get_value("player", "bestTime", 0)

func _save_progress() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("player", "country", playerCountry)
	cfg.set_value("player", "name", playerName)
	cfg.set_value("player", "time", playerTime)
	cfg.set_value("player", "bestTime", bestTime)
	cfg.save(SAVE_PATH)

func setup_race() -> void:
	var http := HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(_on_opponents_loaded.bind(http))
	var device_id := OS.get_unique_id()
	http.request(Global.API_BASE + "/scores/random?device_id=" + device_id)

func _on_opponents_loaded(_result: int, _response_code: int, _headers: PackedStringArray, body: PackedByteArray, http: HTTPRequest) -> void:
	http.queue_free()
	var json := JSON.new()
	if (json.parse(body.get_string_from_utf8()) == OK and json.data is Dictionary):
		raceData = json.data.get("scores", [])
		print(raceData)
		playerPos = randi_range(0, raceData.size())
		raceData.insert(playerPos, {"player_name": ("%s (You)" % playerName) if playerName else "You", "country": playerCountry})
		$GameScene.setup_race(raceData, playerPos)

func start() -> void:
	%StartButton.hide()
	%LeaderboardsButton.hide()

	%Label.text = "On your marks..."
	$GameScene.on_your_marks()

	await get_tree().create_timer(2.0).timeout
	%Label.text = "Set..."
	$GameScene.prepare_runners()
	raceSet = true

	var delay = randf_range(2.0, 5.0)
	$PistolTimer.start(delay)

func fire_pistol() -> void:
	pistolFired = true
	fireTime = Time.get_ticks_usec()
	%Label.text = ""

func _input(event: InputEvent) -> void:
	if (event is InputEventMouseButton):
		if (event.button_index == MOUSE_BUTTON_LEFT && event.pressed):
			if (pistolFired):
				var click_usec: int = Time.get_ticks_usec()
				var elapsed_usec: int = click_usec - fireTime
				pistolFired = false
				raceSet = false
				_report_time(elapsed_usec)
				$GameScene.start_running()
			elif (raceSet):
				raceSet = false
				$GameScene.false_start(playerPos)
				$PistolTimer.stop()
				%Label.text = "False start!"
				%RetryButton.show()

func _report_time(usec: int) -> void:
	playerTime = usec

	var ms: float = usec / 1000.0
	var seconds: float = usec / 1_000_000.0
	print("%d microseconds (µs)" % usec)
	print("%.3f milliseconds (ms)" % ms)
	print("%.6f seconds (s)" % seconds)

	$GameScene.update_player_time(playerPos, usec)

	await get_tree().create_timer(1.0).timeout
	var newPB:bool = playerTime < bestTime && ms < 1000
	if (newPB):
		_save_progress()
		%SubmitScoreButton.show()
	else:
		%RetryButton.show()

	%LeaderboardsButton.show()

func _on_country_changed(code: String) -> void:
	playerCountry = code
	_save_progress()
	%CountrySelector.hide()
	$ScoreSubmission.update_country()
	_update_ui()

func _update_country() -> void:
	%PlayerInfo.set_country(playerCountry)

func _on_country_button_pressed() -> void:
	%CountrySelector.show()

func open_leaderboard() -> void:
	%Leaderboard.show()
	%Leaderboard.refresh()
	$ScoreSubmission.hide()
	$GameButtons.hide()
	%LeaderboardsButton.hide()

func close_leaderboard() -> void:
	%Leaderboard.hide()
	%LeaderboardsButton.show()
	$GameButtons.show()

func retry() -> void:
	get_tree().reload_current_scene()

func _on_delete_data_button_pressed() -> void:
	DirAccess.remove_absolute(ProjectSettings.globalize_path(SAVE_PATH))
	playerCountry = ""
	playerName = ""
	playerTime = 0
	bestTime = 0
	get_tree().reload_current_scene()

func _on_pistol_timer_timeout() -> void:
	fire_pistol()
	$GameScene.pistol_fire()

func _on_submit_score_button_pressed() -> void:
	$ScoreSubmission.open()
	%SubmitScoreButton.hide()
	%LeaderboardsButton.hide()

func _on_score_submission_score_submitted() -> void:
	bestTime = playerTime
	_save_progress()
	open_leaderboard()
	%SubmitScoreButton.hide()
	%RetryButton.show()

func _on_score_submission_country_button_pressed() -> void:
	%CountrySelector.show()
