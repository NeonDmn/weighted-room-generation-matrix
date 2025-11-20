extends Resource
class_name MapData

signal static_data_changed(data : MapData)
signal data_delete_request(data : MapData)

@export var id: String = "None" :
	set(v):
		old_id = id
		id = v
		static_data_changed.emit(self)
		
@export var display_name: String = "Please set a name" :
	set(v):
		display_name = v
		static_data_changed.emit(self)

var old_id : String

func _init(id: String, display_name: String) -> void:
	if display_name.is_empty():
		self.display_name = id
	else:
		self.display_name = display_name

	self.id = id.to_lower().to_snake_case()

static func new_instance(id: String, editor_name: String, percentage: float) -> MapDataInstance:
	var data = MapData.new(id, editor_name)
	return MapDataInstance.new(data, percentage)


func delete_data() -> void:
	data_delete_request.emit(self)
	
