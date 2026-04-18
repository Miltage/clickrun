class_name Main
extends Control

const SAVE_PATH = "user://save.cfg"

static var country:String
static var playerName:String
static var playerTime:int
static var bestTime:int

var fireTime:int = 0
var pistolFired:bool = false

func _ready() -> void:
	%ScoreSubmission.hide()
	%RetryButton.hide()
	%Label.text = ""
	%Response.text = ""
	%PlayerName.text = ""

	_load_progress()

	if (bestTime < 1):
		bestTime = 9223372036854775807 # max int

	if (!country):
		country = Global.pick_random_country()
		%CountrySelector.show()

	if (playerName):
		%NameInput.text = playerName
		%PlayerName.text = playerName

	_update_country()

func _load_progress() -> void:
	var cfg := ConfigFile.new()
	if (cfg.load(SAVE_PATH) != OK):
		return
	country = cfg.get_value("player", "country", "")
	playerName = cfg.get_value("player", "name", "")
	playerTime = cfg.get_value("player", "time", 0)
	bestTime = cfg.get_value("player", "bestTime", 0)

func _save_progress() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("player", "country", country)
	cfg.set_value("player", "name", playerName)
	cfg.set_value("player", "time", playerTime)
	cfg.set_value("player", "bestTime", bestTime)
	cfg.save(SAVE_PATH)

func start() -> void:
	%StartButton.hide()

	%Label.text = "Get ready..."

	var delay = randf_range(2.0, 8.0)
	await get_tree().create_timer(delay).timeout
	fire_pistol()

func fire_pistol() -> void:
	pistolFired = true
	fireTime = Time.get_ticks_usec()
	%Label.text = "BANG!"

func _input(event: InputEvent) -> void:
	if (pistolFired && event is InputEventMouseButton):
		if (event.button_index == MOUSE_BUTTON_LEFT && event.pressed):
			var click_usec: int = Time.get_ticks_usec()
			var elapsed_usec: int = click_usec - fireTime
			pistolFired = false
			_report_time(elapsed_usec)

func _report_time(usec: int) -> void:
	playerTime = usec

	var newPB:bool = false
	if (playerTime < bestTime):
		newPB = true
		bestTime = playerTime

	var ms: float = usec / 1000.0
	var seconds: float = usec / 1_000_000.0
	%Label.text = "%.3f milliseconds (ms)" % ms
	print("  %d microseconds (µs)" % usec)
	print("  %.3f milliseconds (ms)" % ms)
	print("  %.6f seconds (s)" % seconds)

	await get_tree().create_timer(1.0).timeout
	if (newPB):
		_save_progress()
		%ScoreSubmission.show()
		%SubmitButton.disabled = false
		%NameInput.editable = true
	else:
		%RetryButton.show()

func submit_score() -> void:
	%Response.text = ""

	if (%NameInput.text.length() < 3):
		%Response.text = "Name needs to be at least 3 characters in length."
		return

	playerName = %NameInput.text
	_save_progress()

	%SubmitButton.disabled = true
	%NameInput.editable = false

	var http := HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(_on_score_submitted.bind(http))

	var body := JSON.stringify({
		"player_name": playerName,
		"device_id": OS.get_unique_id(),
		"country": country,
		"reaction_us": playerTime
	})

	var err := http.request(Global.API_BASE + "/scores", ["Content-Type: application/json"], HTTPClient.METHOD_POST, body)
	if (err != OK):
		%Response.text = "Request error: %d" % err
		%SubmitButton.disabled = false
		%NameInput.editable = true
		http.queue_free()

func _on_score_submitted(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray, http: HTTPRequest) -> void:
	http.queue_free()
	%SubmitButton.disabled = false
	%NameInput.editable = true
	%ScoreSubmission.hide()
	%RetryButton.show()

	if (result != HTTPRequest.RESULT_SUCCESS):
		%Response.text = "Network error. Please try again."
		return

	var json := JSON.new()
	var server_message: String
	if (json.parse(body.get_string_from_utf8()) == OK and json.data is Dictionary):
		server_message = json.data.get("error", "")

	if (response_code < 200 or response_code >= 300):
		%Response.text = server_message if server_message else "Server error: %d" % response_code
		return

	%Response.text = server_message if server_message else "Score submitted!"

func _on_country_changed(code: String) -> void:
	country = code
	_save_progress()
	%CountrySelector.hide()
	_update_country()

func _update_country() -> void:
	%CountryButton.texture_normal = load("res://textures/flags/%s.png" % country)

func _on_country_button_pressed() -> void:
	%CountrySelector.show()

func _on_leaderboards_button_pressed() -> void:
	%Leaderboard.show()
	%Leaderboard.refresh()

func retry() -> void:
	%RetryButton.hide()
	%StartButton.show()