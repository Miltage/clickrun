extends Control

signal close

const SCORE_LIST_ITEM = preload("res://scenes/score_list_item.tscn")

var _scores_loaded: bool = false
var _player_rank: int = -1
var _player_score: Dictionary = {}

func refresh() -> void:
	_scores_loaded = false
	_player_rank = -1
	_player_score = {}
	for child in %Scores.get_children():
		child.queue_free()
	fetch_scores()
	_fetch_player_score()

func fetch_scores(country: String = "") -> void:
	var url = Global.API_BASE + "/scores/top?n=10"
	if (country != ""):
		url += "&country=" + country

	var http := HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(_on_scores_received.bind(http))

	%Status.text = "Fetching scores..."
	%Status.show()

	var err := http.request(url)
	if (err != OK):
		print("http request error")
		http.queue_free()

func _on_scores_received(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray, http: HTTPRequest) -> void:
	http.queue_free()

	if (result != HTTPRequest.RESULT_SUCCESS or response_code < 200 or response_code >= 300):
		prints("error fetching scores:", response_code)
		%Status.text = "Error occured"
		return

	var json := JSON.new()
	if (json.parse(body.get_string_from_utf8()) != OK or not json.data is Dictionary):
		print("error parsing JSON")
		return

	%Status.hide()

	var scores:Array = json.data.get("scores", [])

	for child in %Scores.get_children():
		child.queue_free()

	for score in scores:
		var item = SCORE_LIST_ITEM.instantiate()
		%Scores.add_child(item)
		item.set_meta("rank", score.get("rank", -1))

		var country_code: String = score.get("country", "")
		if (country_code != ""):
			item.set_country(country_code)

		item.set_rank(score.get("rank", 0))
		item.set_player_name(score.get("player_name", ""))
		item.set_time_us(score.get("reaction_us", 0))

	if (scores.size() == 0):
		%Status.text = "No scores yet."
		%Status.show()

	_scores_loaded = true
	_update_player_row()

func _fetch_player_score() -> void:
	var device_id := OS.get_unique_id()
	var http := HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(_on_player_score_received.bind(http))

	var err := http.request(Global.API_BASE + "/scores/device/" + device_id)
	if (err != OK):
		http.queue_free()

func _on_player_score_received(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray, http: HTTPRequest) -> void:
	http.queue_free()

	if (result != HTTPRequest.RESULT_SUCCESS or response_code < 200 or response_code >= 300):
		return

	var json := JSON.new()
	if (json.parse(body.get_string_from_utf8()) != OK or not json.data is Dictionary):
		return

	_player_rank = json.data.get("rank", -1)
	_player_score = json.data.get("score", {})
	_update_player_row()

func _update_player_row() -> void:
	if (not _scores_loaded or _player_rank < 1):
		return

	for child in %Scores.get_children():
		var existing := child as ScoreListItem
		if (existing and existing.get_meta("rank", -1) == _player_rank):
			existing.set_highlighted(true)
			return

	if (_player_rank > 11):
		var ellipsis = SCORE_LIST_ITEM.instantiate()
		%Scores.add_child(ellipsis)
		ellipsis.set_as_ellipsis()

	var item = SCORE_LIST_ITEM.instantiate()
	%Scores.add_child(item)
	item.set_meta("rank", _player_rank)
	item.set_rank(_player_rank)
	item.set_player_name(_player_score.get("player_name", ""))
	item.set_time_us(_player_score.get("reaction_us", 0))
	var country_code: String = _player_score.get("country", "")
	if (country_code != ""):
		item.set_country(country_code)
	item.set_highlighted(true)

func _on_close_button_pressed() -> void:
	close.emit()
