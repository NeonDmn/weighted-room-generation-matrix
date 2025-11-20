class_name MapDataInstance extends RefCounted

signal dynamic_data_changed
signal data_instance_deleted

var map_data: MapData
var percentage: float = 0 :
	set(v):
		percentage = clampf(v, 0, 1)
		dynamic_data_changed.emit()

var id: String:
	get:
		return map_data.id
	set(v):
		map_data.id = v

var display_name: String:
	get:
		return map_data.display_name
	set(v):
		map_data.display_name = v


func _init(data: MapData, percentage: float = 0) -> void:
	map_data = data
	map_data.static_data_changed.connect(_on_static_data_changed_event)
	map_data.data_delete_request.connect(_on_data_deleted)
	self.percentage = percentage

func _on_static_data_changed_event(data: MapData):
	dynamic_data_changed.emit()

func _on_data_deleted(data: MapData) -> void:
	delete_instance()

func delete_instance() -> void:
	data_instance_deleted.emit()

func update_id(new_id: String):
	var old = map_data.name
	Global.update_map_id(old, new_id)


func update_display_name(new_name: String):
	map_data.display_name = new_name
	Global.map_display_name_updated.emit(map_data.name)
