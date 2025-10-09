extends Control

@onready var toast_label: Label = $MarginContainer/MarginContainer/ToastLabel
@onready var timer: Timer = $Timer

var timed_out : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate.a = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if timed_out and modulate.a > 0.0:
		modulate.a = lerp(modulate.a, 0.0, delta * 2.0)

func show_toast(text):
	toast_label.text = text
	modulate.a = 1.0
	timed_out = false
	timer.start()

func _on_timer_timeout() -> void:
	timed_out = true
