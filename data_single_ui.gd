extends PanelContainer

@onready var title_label: Label = $MarginContainer/VBoxContainer/TitleLabel
@onready var description_label: Label = $MarginContainer/VBoxContainer/DescriptionLabel

func get_title():
	return title_label.text

func set_title(text):
	title_label.text = text

func get_description():
	return description_label.text

func set_description(text):
	description_label.text = text
