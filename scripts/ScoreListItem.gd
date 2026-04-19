class_name ScoreListItem
extends Control

@onready var flag: TextureRect = $Container/Flag
@onready var player_name: Label = $Container/PlayerName
@onready var time: Label = $Container/Time
@onready var rank: Label = $Container/Rank

var _countryCode:String

func set_player_name(new_name: String) -> void:
	player_name.text = new_name

func set_time_us(reaction_us: int) -> void:
	time.text = "%.3f ms" % (reaction_us / 1000.0)

func set_country(country_code: String) -> void:
	_countryCode = country_code
	var flag_path = "res://textures/flags/%s.png" % country_code
	if (ResourceLoader.exists(flag_path)):
		flag.texture = load(flag_path)

func set_rank(n:int) -> void:
	rank.text = str(n)

func set_highlighted(on: bool) -> void:
	modulate = Color(1.0, 0.85, 0.2) if on else Color.WHITE

func set_as_ellipsis() -> void:
	flag.hide()
	rank.text = ""
	player_name.text = "..."
	time.hide()

func _on_flag_mouse_entered() -> void:
	if (!Global.countryCodes.has(_countryCode)): return
	Tooltip.show_tip(Global.countryCodes[_countryCode])

func _on_flag_mouse_exited() -> void:
	Tooltip.clear()