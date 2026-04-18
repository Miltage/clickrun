class_name ScoreListItem
extends HBoxContainer

@onready var flag: TextureRect = $Flag
@onready var player_name: Label = $PlayerName
@onready var time: Label = $Time
@onready var pos: Label = $Position

func set_player_name(new_name: String) -> void:
	player_name.text = new_name

func set_time_us(reaction_us: int) -> void:
	time.text = "%.0f ms" % (reaction_us / 1000.0)

func set_country(country_code: String) -> void:
	var flag_path = "res://textures/flags/%s.png" % country_code
	if (ResourceLoader.exists(flag_path)):
		flag.texture = load(flag_path)

func set_pos(n:int) -> void:
	pos.text = str(n)