extends PanelContainer
class_name MapMatrixEntry

const DESTINATION_ENTRY = preload("res://destination_entry.tscn")

@onready var origin_map_name: Label = $HBoxContainer/OriginMapName
@onready var destination_container: HFlowContainer = $HBoxContainer/DestinationContainer

var origin_map_data: MapData

func _ready() -> void:
	Utils.clear_children(destination_container)
	#Global.map_display_name_updated.connect(on_display_name_updated)


func initialize_data(data: MapData):
	origin_map_data = data
	origin_map_data.static_data_changed.connect(_on_map_data_updated)
	origin_map_data.data_delete_request.connect(_on_map_data_deleted)
	_on_map_data_updated(origin_map_data)


func _on_map_data_updated(data: MapData):
	origin_map_name.text = origin_map_data.display_name

func _on_map_data_deleted(data : MapData) -> void:
	self.queue_free()


func _on_add_destination_button_pressed() -> void:
	if Global.selected_map_data == null:
		print("No map data selected to add")
		return
	var data := Global.selected_map_data
	if has_child_map_data(data):
		print("This map already has a connection to " + data.display_name)
		return
	add_destination_entry(data, 1)

# Use this for loading imported data
func add_destination_entry(data: MapData, percentage: float):
	var instance = DESTINATION_ENTRY.instantiate()
	destination_container.add_child(instance)
	instance.initialize_with_data(data)
	instance.instance.percentage = percentage


func get_export_string() -> String:
	var export_str = "{\"Name\":\"" + origin_map_data.id + "\","
	export_str += "\"EditorName\":\"" + origin_map_data.display_name + "\","
	export_str += "\"ProbabilityMap\":{"
	
	var children := destination_container.get_children()
	for i in range(children.size()):
		var instance : MapDataInstance = children[i].instance
		export_str += "\"" + instance.id + "\":" + str(instance.percentage)
		if i < children.size()-1:
			export_str += ","
		else:
			export_str += ""
	export_str += "}}"
	return export_str

func has_child_map_data(data: MapData) -> bool:
	for c in destination_container.get_children():
		if c.instance.id == data.id:
			return true
	return false


func _on_normalize_pertentages_button_pressed() -> void:
	var percentages : PackedFloat32Array
	var percentages_normalized : PackedFloat32Array
	var destinations = destination_container.get_children()
	for c in destinations:
		var entry = c as MapDestinationEntry
		percentages.append(entry.instance.percentage)
	
	var sum : float
	for number in percentages:
		sum += number
	
	for number in percentages:
		var val = remap(number, 0, sum, 0, 1)
		percentages_normalized.append(val)
	
	for i in range(destinations.size()):
		var entry = destinations[i] as MapDestinationEntry
		entry.instance.percentage = percentages_normalized[i]
