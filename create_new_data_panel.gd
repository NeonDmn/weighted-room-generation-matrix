extends VBoxContainer

#signal new_map_created(instance : MapDataInstance)

@onready var display_input: LineEdit = $DisplayInput
@onready var internal_input: LineEdit = $InternalInput


func _on_create_data_button_pressed() -> void:
	var disp_name: String = display_input.text
	var int_name: String = internal_input.text
	
	if int_name.is_empty():
		printerr("You must specify an internal ID")
		return
	
	if Global.does_map_exist(int_name):
		var data = Global.get_map_by_id(int_name)
		printerr("Map with given id already exists: " + data.id + " name: " + data.display_name)
		return
	
	var data := MapData.new(int_name, disp_name)
	print("Map instance created! Id: " + data.id + ", Display name: " + data.display_name)
	#new_map_created.emit(instance)
	SignalBus.emit_new_map_data_created(data)
	
	display_input.clear()
	internal_input.clear()
	#Global.add_new_map(int_name, disp_name)
	#print(Global.get_map_by_id(int_name).display_name)
