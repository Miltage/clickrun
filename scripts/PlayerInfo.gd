class_name PlayerInfo
extends HBoxContainer

var _highlighted:bool

func _ready() -> void:
	%PlayerName.text = ""
	hide_time()

func set_player_name(playerName:String) -> void:
	%PlayerName.text = playerName

func set_country(code:String) -> void:
	%CountryButton.texture = load("res://textures/flags/%s.png" % code)

func set_time(usec:int) -> void:
	var ms: float = usec / 1000.0
	if (ms > 1000):
		%Time.text = "[Disqualified]"
	elif (usec > 0):
		%Time.text = "[%.3fms]" % ms
	else:
		%Time.text = ""

func hide_time() -> void:
	%Time.hide()

func show_time() -> void:
	%Time.show()

func set_highlighted(on: bool) -> void:
	_highlighted = on
	make_visible()

func make_visible() -> void:
	modulate = Color(1.0, 0.85, 0.2) if _highlighted else Color.WHITE

func make_hidden() -> void:
	modulate = Color.TRANSPARENT