extends PanelContainer

@onready var title_label: Label = $MarginContainer/VBoxContainer/TitleLabel
@onready var description_label: Label = $MarginContainer/VBoxContainer/DescriptionLabel
@onready var outline: Panel = $Outline
@onready var panel: Panel = $MarginContainer/Panel

var selected: bool = false

func get_title():
	return title_label.text

func set_title(text):
	title_label.text = text

func get_description():
	return description_label.text

func set_description(text):
	description_label.text = text

func get_selected() -> bool:
	return selected

func _on_selected() -> void:
	selected = not selected
	if selected:
		outline.visible = true
	else:
		outline.visible = false

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			print("mouse button")
			_on_selected()
			panel.add_theme_constant_override("border_width_left", 3)
			panel.add_theme_color_override("border_color", Color(1, 1, 1))
