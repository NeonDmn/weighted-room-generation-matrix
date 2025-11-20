extends Node

signal new_map_data_created(data: MapData)

func emit_new_map_data_created(data: MapData):
	new_map_data_created.emit(data)
