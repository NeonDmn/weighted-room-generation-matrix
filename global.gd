extends Node

signal map_selected

var maps : Dictionary[StringName, MapData]

var selected_map_data: MapData
var selected_map_instance: MapDataInstance
var is_selected_instance : bool

func _ready() -> void:
	SignalBus.new_map_data_created.connect(_on_new_map_data_created)

func _on_new_map_data_created(data: MapData):
	maps[data.id] = data
	data.static_data_changed.connect(_on_static_map_data_changed)
	data.data_delete_request.connect(_on_data_delete_request)

func _on_static_map_data_changed(data : MapData):
	if does_map_exist(data.old_id):
		maps.erase(data.old_id)
		maps[data.id] = data

func _on_data_delete_request(data: MapData) -> void:
	maps.erase(data.id)

func get_map_by_id(id: String) -> MapData:
	if maps.has(id):
		return maps[id]
	return null

func does_map_exist(id: String) -> bool:
	return maps.has(id)


func select_map_data(data: MapData):
	is_selected_instance = false
	selected_map_data = data
	map_selected.emit()

func select_map_instance(instance: MapDataInstance):
	is_selected_instance = true
	selected_map_instance = instance
	map_selected.emit()
