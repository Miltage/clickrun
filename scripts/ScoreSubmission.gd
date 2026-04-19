class_name ScoreSubmission
extends Control

signal score_submitted
signal country_button_pressed

func open() -> void:
	%Response.text = ""
	%NameInput.text = Main.playerName
	%NameInput.editable = Main.playerID < 1
	print(Main.playerID)
	update_country()
	show()

func set_time(usec:int) -> void:
	var ms: float = usec / 1000.0
	if (ms > 1000):
		%Time.text = "[Disqualified]"
	elif (usec > 0):
		%Time.text = "[%.3fms]" % ms
	else:
		%Time.text = ""

func submit_score() -> void:
	%Response.text = ""

	if (%NameInput.text.length() < 3):
		%Response.text = "Name needs to be at least 3 characters in length."
		return
	elif (%NameInput.text.length() > 20):
		%Response.text = "Name cannot be longer than 20 characters."
		return

	Main.playerName = %NameInput.text

	%SubmitButton.disabled = true
	%NameInput.editable = false

	var http := HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(_on_score_submitted.bind(http))

	var body := JSON.stringify({
		"playerId": Main.playerID,
		"player_name": Main.playerName,
		"country": Main.playerCountry,
		"reaction_us": Main.playerTime
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
	%NameInput.editable = false

	if (result != HTTPRequest.RESULT_SUCCESS):
		%Response.text = "Network error. Please try again."
		return

	var json := JSON.new()
	var server_message: String
	if (json.parse(body.get_string_from_utf8()) == OK and json.data is Dictionary):
		server_message = json.data.get("error", "")
		var score_data: Dictionary = json.data.get("score", {})
		if (score_data.has("id")):
			Main.playerID = score_data["id"]

	if (response_code < 200 or response_code >= 300):
		%Response.text = server_message if server_message else "Server error: %d" % response_code
		return

	%Response.text = server_message if server_message else "Score submitted!"

	score_submitted.emit()

func _on_country_button_pressed() -> void:
	country_button_pressed.emit()

func update_country() -> void:
	%CountryButton.texture_normal = load("res://textures/flags/%s.png" % Main.playerCountry)
