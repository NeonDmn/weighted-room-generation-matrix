extends Node

@onready var map_matrix_container: VBoxContainer = %MapMatrixContainer

func export_matrix(path: String):
	var export_str = "["
	export_str += map_matrix_container.get_export_string()
	export_str += "]"
	
	print(export_str)
	
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		print(FileAccess.get_open_error())
		return
	
	file.store_string(export_str)
	file.close()
	

func import_matrix(json_string : String):
	print(json_string)
	var json := JSON.new()
	var error := json.parse(json_string)
	if error == OK:
		pass
	else:
		printerr(error)
		return
	
	var entryArray = json.data
	for i in range(entryArray.size()):
		var json_entry = entryArray[i]
		var display_name: String
		if json_entry.has("EditorName"):
			display_name = json_entry["EditorName"]
		else:
			display_name = json_entry["Name"]
		var origin_data := MapData.new(json_entry["Name"], display_name)
		print("Adding new origin: " + origin_data.id)
		SignalBus.emit_new_map_data_created(origin_data)
		
	for i in range(entryArray.size()):
		var entry := map_matrix_container.get_child(i) as MapMatrixEntry
		var destination_map : Dictionary = entryArray[i]["ProbabilityMap"]
		for destination_id in destination_map:
			var destination_data = Global.get_map_by_id(destination_id)
			if destination_data == null:
				printerr("Failed to find existing MapID while importing: " + destination_id)
				continue
			print("Adding destination with id: " + destination_data.id + " and %" + str(destination_map[destination_id]))
			entry.add_destination_entry(destination_data, destination_map[destination_id])
	

func _on_import_button_pressed() -> void:
	%ImportFileDialog.popup()


func _on_export_button_pressed() -> void:
	#export_matrix()
	%ExportFileDialog.popup()


func _on_export_file_dialog_file_selected(path: String) -> void:
	print(path)
	export_matrix(path)


func _on_import_file_dialog_file_selected(path: String) -> void:
	print(path)
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		printerr(FileAccess.get_open_error())
		return
	var content := file.get_as_text()
	file.close()

	import_matrix(content)
