extends Control

var exec_path = "error"
var save_file_name = "SaveData.json"
var load_file_name = "Creatures.json"
var full_save_path = "error"
var full_load_path = "error"

var data_single_ui_scene = preload("res://data_single_ui.tscn")

@onready var v_box_container: VBoxContainer = $ScrollContainer/VBoxContainer

@onready var add_data_button: Button = $AddDataButton
@onready var remove_selected_button: Button = $RemoveSelectedButton
@onready var save_data_button: Button = $SaveDataButton
@onready var load_data_button: Button = $LoadDataButton

@onready var title_line_edit: LineEdit = $TitleLineEdit
@onready var description_line_edit: LineEdit = $DescriptionLineEdit
@onready var notification_toast: Control = $NotificationToast
@onready var save_data_line_edit: LineEdit = $SaveDataLineEdit
@onready var load_data_line_edit: LineEdit = $LoadDataLineEdit

var data_dict: Dictionary


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	clear_data_visuals()
	
	if OS.has_feature("release"):
		exec_path = OS.get_executable_path().get_base_dir()
	else:
		exec_path = "res://"
	full_save_path = exec_path + "/" + save_file_name
	full_load_path = exec_path + "/" + load_file_name
	
	save_data_line_edit.text = save_file_name
	load_data_line_edit.text = load_file_name
	
	var title_text = full_save_path
	var description_text = full_load_path
	
	data_dict[title_text] = description_text
	var inst = data_single_ui_scene.instantiate()
	v_box_container.add_child(inst)
	inst.set_title(title_text)
	inst.set_description(description_text)
	
	add_data_button.pressed.connect(_on_add_data_button_pressed)
	remove_selected_button.pressed.connect(_on_remove_selected_button_pressed)
	save_data_button.pressed.connect(_on_save_data_button_pressed)
	load_data_button.pressed.connect(_on_load_data_button_pressed)



func _on_add_data_button_pressed() -> void:
	var title_text = title_line_edit.text
	var description_text = description_line_edit.text
	
	if not title_text or not description_text:
		notification_toast.show_toast("Fields can't be empty!")
		return
		
	if not data_dict.has(title_text):
		data_dict[title_text] = description_text
		var inst = data_single_ui_scene.instantiate()
		v_box_container.add_child(inst)
		inst.set_title(title_text)
		inst.set_description(description_text)
	else: #key already exists, find it's object and change it's description
		var a: Array = data_dict.keys()
		var inst = v_box_container.get_child(a.find(title_text))
		inst.set_description(description_text)
		data_dict[title_text] = description_text



func _on_remove_selected_button_pressed() -> void:
	print("Removing selected item(s)")
	if not v_box_container.get_child_count():
		notification_toast.show_toast("Nothing to remove!")
		return
	
	var selected_indices_array: Array
	for child in v_box_container.get_children():
		if child.get_selected():
			selected_indices_array.append(child.get_index())
	
	selected_indices_array.reverse()
	for i in selected_indices_array:
		data_dict.erase(v_box_container.get_child(i).get_title())
		v_box_container.get_child(i).queue_free()



func _on_save_data_button_pressed() -> void:
	print("Saving data to JSON file")
	if not DirAccess.dir_exists_absolute(exec_path):
		notification_toast.show_toast("Save Directory doesn't exist!")
		return
	var file = FileAccess.open(full_save_path, FileAccess.WRITE)
	var json_text = JSON.stringify(data_dict, "\t")
	file.store_string(json_text)



func _on_load_data_button_pressed() -> void:
	print("Loading data from JSON file")
	#notification_toast.show_toast("Not Implemented!")
	if FileAccess.file_exists(full_load_path):
		var file = FileAccess.open(full_load_path, FileAccess.READ)
		
		var json_string = file.get_as_text()
		var json = JSON.new()
		var result = json.parse(json_string)
		if result != OK:
			var error_msg : String = "JSON Parse Error:" + str(json.get_error_message()) + "at line" + str(json.get_error_line())
			print(error_msg)
			notification_toast.show_toast(error_msg)
			return
		
		var bestiary_entries_array = json.data
		
		clear_data_visuals()
		data_dict.clear()
		for entry in bestiary_entries_array:
			var entry_dictionary: Dictionary = entry
			var description_dictionary: Dictionary = entry_dictionary["description"]
			var title_text: String = description_dictionary["name"]
			var description_text: String = str(description_dictionary["cr"])
			
			var inst = data_single_ui_scene.instantiate()
			v_box_container.add_child(inst)
			inst.set_title(title_text)
			inst.set_description(description_text)
			data_dict[title_text] = description_text
	else:
		print("No file to load!")
		notification_toast.show_toast("No file to load!")
	



func clear_data_visuals() -> void:
	for child in v_box_container.get_children():
		child.queue_free()
