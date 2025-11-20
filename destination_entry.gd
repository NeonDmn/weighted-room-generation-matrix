extends Panel
class_name MapDestinationEntry

@onready var map_name: Label = %MapNameLabel
@onready var spawn_percentage: Label = %PercentLabel
@onready var progress_bar: ProgressBar = $ProgressBar


var instance: MapDataInstance

func initialize_with_data(data: MapData):
	instance = MapDataInstance.new(data, 0)
	instance.dynamic_data_changed.connect(_on_map_data_update)
	instance.data_instance_deleted.connect(_on_instance_deleted)
	map_name.text = instance.display_name
	update_percentage()

func _on_map_data_update():
	map_name.text = instance.display_name
	update_percentage()

func _on_instance_deleted() -> void:
	queue_free()

func add_percentage(delta: float):
	instance.percentage += delta


func _on_button_pressed() -> void:
	#Global.matrix_entry_update = func():
	#	update_percentage_text()
	#	percentage_change_forced.emit(self.get_index())
	Global.select_map_instance(instance)
		
func update_percentage():
	spawn_percentage.text = "%0.2f" % (instance.percentage*100)
	progress_bar.value = instance.percentage
