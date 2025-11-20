extends Control

const DRAWER_ENTRY = preload("res://drawer_entry.tscn")
@onready var entry_container: HFlowContainer = $VBoxContainer/ScrollContainer/HFlowContainer
#@onready var create_new_data_panel: VBoxContainer = $"../VBoxContainer/CreateNewDataPanel"


func _ready() -> void:
	#Global.new_map_created.connect(on_new_map_created)
	SignalBus.new_map_data_created.connect(_on_new_map_created_event)
	_clear_map_buttons()


func _on_new_map_created_event(data: MapData):
	var instance = DRAWER_ENTRY.instantiate()
	entry_container.add_child(instance)
	data.data_delete_request.connect(_on_data_deleted)
	instance.initialize(data)

func _on_data_deleted(data: MapData) -> void:
	var entries := entry_container.get_children()
	for entry in entries:
		if entry.data == data:
			entry_container.remove_child(entry)
			entry.queue_free()

func _clear_map_buttons():
	for n in entry_container.get_children():
		entry_container.remove_child(n)
		n.queue_free()
