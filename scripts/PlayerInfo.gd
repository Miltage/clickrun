class_name PlayerInfo
extends HBoxContainer

func _ready() -> void:
	%PlayerName.text = ""

func set_player_name(playerName:String) -> void:
	%PlayerName.text = playerName

func set_country(code:String) -> void:
	%CountryButton.texture = load("res://textures/flags/%s.png" % code)