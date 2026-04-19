extends PanelContainer

var _targetAlpha:float = 0

func _ready() -> void:
	modulate.a = 0

func _process(_delta: float) -> void:
	modulate.a = lerp(modulate.a, _targetAlpha, 0.3)
	var mouse := get_viewport().get_mouse_position()
	var vp := get_viewport().get_visible_rect().size
	var offset := Vector2(10, 10)
	if mouse.x + offset.x + size.x > vp.x:
		offset.x = -offset.x - size.x
	if mouse.y + offset.y + size.y > vp.y:
		offset.y = -offset.y - size.y
	position = mouse + offset

func show_tip(info:String) -> void:
	$Label.text = info
	_targetAlpha = 1.0
	reset_size()

func clear() -> void:
	_targetAlpha = 0.0