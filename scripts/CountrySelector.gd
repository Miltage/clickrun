@tool
class_name CountrySelector
extends Control

signal country_selected(code:String)

func _ready() -> void:
	var sorted_codes := Global.countryCodes.keys()
	sorted_codes.sort_custom(func(a, b): return Global.countryCodes[a] < Global.countryCodes[b])
	for code in sorted_codes:
		var flagButton:TextureButton = TextureButton.new()
		flagButton.texture_normal = load("res://textures/flags/%s.png" % code)
		flagButton.pressed.connect(func(): country_selected.emit(code))
		flagButton.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		flagButton.mouse_entered.connect(func(): Tooltip.show_tip(Global.countryCodes[code]))
		flagButton.mouse_exited.connect(func(): Tooltip.clear())
		%Grid.add_child(flagButton)
