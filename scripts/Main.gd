class_name Main
extends Node2D

var fireTime:int = 0
var pistolFired:bool = false

func _ready() -> void:
	# Start after a random delay to prevent anticipation
	var delay = randf_range(1.0, 3.0)
	await get_tree().create_timer(delay).timeout
	fire_pistol()

func fire_pistol() -> void:
	pistolFired = true
	fireTime = Time.get_ticks_usec()
	print("Event started! Click now.")

func _input(event: InputEvent) -> void:
	if (pistolFired && event is InputEventMouseButton):
		if (event.button_index == MOUSE_BUTTON_LEFT && event.pressed):
			var click_usec: int = Time.get_ticks_usec()
			var elapsed_usec: int = click_usec - fireTime
			pistolFired = false
			_report_time(elapsed_usec)

func _report_time(usec: int) -> void:
	var ms: float = usec / 1000.0
	var seconds: float = usec / 1_000_000.0
	print("Reaction time:")
	print("  %d microseconds (µs)" % usec)
	print("  %.3f milliseconds (ms)" % ms)
	print("  %.6f seconds (s)" % seconds)

