extends Panel

@onready var v_box_container: VBoxContainer = $VBoxContainer
@onready var editor_name_input: LineEdit = $VBoxContainer/EDN_LineEdit
@onready var internal_name_input: LineEdit = $VBoxContainer/IN_LineEdit

@onready var perc_text: LineEdit = $VBoxContainer/PercentageField/HBoxContainer/PercText
@onready var perc_slider: HSlider = $VBoxContainer/PercentageField/HBoxContainer/PercSlider
@onready var percentage_field: Control = $VBoxContainer/PercentageField

@onready var delete_data_btn: Button = $VBoxContainer/HBoxContainer2/DeleteDataBtn
@onready var delete_dest_btn: Button = $VBoxContainer/HBoxContainer2/DeleteDestBtn

var selected_map

func _ready() -> void:
	Global.map_selected.connect(_on_map_selected)
	v_box_container.visible = false

func update_selected_map_info():
	if Global.is_selected_instance:
		selected_map = Global.selected_map_instance
		selected_map.data_instance_deleted.connect(_on_data_deleted)
	else:
		selected_map = Global.selected_map_data
		selected_map.data_delete_request.connect(_on_data_deleted)
	
	if (selected_map == null):
		v_box_container.visible = false
	
	editor_name_input.text = selected_map.display_name
	internal_name_input.text = selected_map.id
	if Global.is_selected_instance:
		perc_slider.value = selected_map.percentage
		percentage_field.visible = true
		delete_data_btn.visible = false
		delete_dest_btn.visible = true
	else:
		percentage_field.visible = false
		delete_data_btn.visible = true
		delete_dest_btn.visible = false
	
	v_box_container.visible = true

func deselect_all() -> void:
	selected_map = null
	v_box_container.visible = false

func _on_data_deleted(data: MapData = null) -> void:
	deselect_all()

func _on_perc_slider_value_changed(value: float) -> void:
	perc_text.text = str(value * 100)
	selected_map.percentage = value
	#Global.update_percentage_in_matrix.emit()
	#percentage_change_forced.emit(self.get_index())
	#Global.update_selected_entry_percentage()


func _on_edn_line_edit_text_submitted(new_text: String) -> void:
	selected_map.display_name = new_text


func _on_in_line_edit_text_submitted(new_text: String) -> void:
	selected_map.id = new_text


func _on_map_selected():
	if selected_map is MapData:
		selected_map.data_delete_request.disconnect(_on_data_deleted)
	elif selected_map is MapDataInstance:
		selected_map.data_instance_deleted.disconnect(_on_data_deleted)
	update_selected_map_info()


func _on_perc_text_text_submitted(new_text: String) -> void:
	perc_slider.value = float(new_text) / 100


func _on_delete_data_btn_pressed() -> void:
	var data = selected_map as MapData
	data.delete_data()


func _on_delete_dest_btn_pressed() -> void:
	var dest = selected_map as MapDataInstance
	dest.delete_instance()
