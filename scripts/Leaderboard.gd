extends Control

const SCORE_LIST_ITEM = preload("res://scenes/score_list_item.tscn")

var _player_rank: int = -1

func refresh() -> void:
	_player_rank = -1
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

	var err := http.request(url)
	if (err != OK):
		http.queue_free()

func _on_scores_received(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray, http: HTTPRequest) -> void:
	http.queue_free()

	if (result != HTTPRequest.RESULT_SUCCESS or response_code < 200 or response_code >= 300):
		return

	var json := JSON.new()
	if (json.parse(body.get_string_from_utf8()) != OK or not json.data is Dictionary):
		return

	var scores: Array = json.data.get("scores", [])

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

	_apply_highlight()

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
	_apply_highlight()

func _apply_highlight() -> void:
	if (_player_rank < 1):
		return
	for child in %Scores.get_children():
		var item := child as ScoreListItem
		if (item):
			item.set_highlighted(item.get_meta("rank", -1) == _player_rank)
