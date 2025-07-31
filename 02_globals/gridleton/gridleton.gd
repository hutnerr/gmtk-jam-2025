extends Node2D

signal loaded

var currentGrid: TileMapLayer
var gridObjects: Dictionary

func _ready() -> void:
	reset()
	
func reset() -> void:
	currentGrid = null
	gridObjects = {}

func loadGridObjects(objects) -> void:
	for object in objects:
		var objpos = object.global_position
		var converted = currentGrid.local_to_map(objpos)
		object.global_position = currentGrid.to_global(currentGrid.map_to_local(converted)) # center in cell
		gridObjects[converted] = object
	loaded.emit()
	print(gridObjects)
