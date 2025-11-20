extends VBoxContainer

const MAP_MATRIX_ENTRY = preload("res://map_matrix_entry.tscn")

func _ready() -> void:
	Utils.clear_children(self)
	SignalBus.new_map_data_created.connect(_on_new_map_created)
	
func _on_new_map_created(data: MapData):
	var instance: MapMatrixEntry = MAP_MATRIX_ENTRY.instantiate()
	self.add_child(instance)
	instance.initialize_data(data)

func _on_data_deleted(data : MapData) -> void:
	var children = get_children()
	for child in children:
		if child.origin_map_data == data:
			remove_child(child)
			child.queue_free()


func get_export_string() -> String:
	var export_str = ""
	var children = get_children()
	for i in range(children.size()):
		var entry := children[i] as MapMatrixEntry
		export_str += entry.get_export_string()
		if i < children.size()-1:
			export_str += ","
		else:
			export_str += ""
	return export_str
	
