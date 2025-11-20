extends PanelContainer

@onready var label: Label = $MarginContainer/Label

var data: MapData

func initialize(data: MapData):
	self.data = data
	label.text = data.display_name
	data.static_data_changed.connect(_on_map_data_changed)

func _on_map_data_changed(data: MapData):
	label.text = data.display_name

func _on_button_pressed() -> void:
	#Global.map_button_clicked.emit(data)
	Global.select_map_data(data)
	#print("Drawer button clicked. ID: " + data.id + " Display name: " + data.display_name)
