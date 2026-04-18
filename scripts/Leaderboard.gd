extends Control

const API_BASE = "http://localhost:3000"
const SCORE_LIST_ITEM = preload("res://scenes/score_list_item.tscn")

func _ready() -> void:
	for child in %Scores.get_children():
		child.queue_free()
	fetch_scores()

func fetch_scores(country: String = "") -> void:
	var url = API_BASE + "/scores/top?n=10"
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

	for i in scores.size():
		var score:Dictionary = scores[i]
		var item = SCORE_LIST_ITEM.instantiate()
		%Scores.add_child(item)

		var country_code: String = score.get("country", "")
		if (country_code != ""):
			item.set_country(country_code)

		item.set_pos(i + 1)
		item.set_player_name(score.get("player_name", ""))
		item.set_time_us(score.get("reaction_us", 0))
