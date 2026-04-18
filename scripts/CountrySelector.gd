@tool
class_name CountrySelector
extends Control

signal country_selected(code:String)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for code in Global.countryCodes:
		var flagButton:TextureButton = TextureButton.new()
		flagButton.texture_normal = load("res://textures/flags/%s.png" % code)
		flagButton.pressed.connect(func(): country_selected.emit(code))
		flagButton.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		%Grid.add_child(flagButton)
