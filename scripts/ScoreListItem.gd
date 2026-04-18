class_name ScoreListItem
extends Control

@onready var flag: TextureRect = $Container/Flag
@onready var player_name: Label = $Container/PlayerName
@onready var time: Label = $Container/Time
@onready var rank: Label = $Container/Rank

func set_player_name(new_name: String) -> void:
	player_name.text = new_name

func set_time_us(reaction_us: int) -> void:
	time.text = "%.3f ms" % (reaction_us / 1000.0)

func set_country(country_code: String) -> void:
	var flag_path = "res://textures/flags/%s.png" % country_code
	if (ResourceLoader.exists(flag_path)):
		flag.texture = load(flag_path)

func set_rank(n:int) -> void:
	rank.text = str(n)

func set_highlighted(on: bool) -> void:
	modulate = Color(1.0, 0.85, 0.2) if on else Color.WHITE