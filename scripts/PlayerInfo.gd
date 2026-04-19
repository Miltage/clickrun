class_name PlayerInfo
extends HBoxContainer

func _ready() -> void:
	%PlayerName.text = ""
	hide_time()

func set_player_name(playerName:String) -> void:
	%PlayerName.text = playerName

func set_country(code:String) -> void:
	%CountryButton.texture = load("res://textures/flags/%s.png" % code)

func set_time(usec:int) -> void:
	if (usec > 0):
		var ms: float = usec / 1000.0
		%Time.text = "[%.3fms]" % ms
	else:
		%Time.text = ""

func hide_time() -> void:
	%Time.hide()

func show_time() -> void:
	%Time.show()