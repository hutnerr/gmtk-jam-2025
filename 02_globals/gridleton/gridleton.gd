extends Node2D

var currentGrid: TileMapLayer
var gridObjects: Dictionary

func _ready() -> void:
	reset()
	

func reset() -> void:
	currentGrid = null
	gridObjects = {}

func loadGridObject() -> void:
	# look through the current grid
	print(currentGrid.get_used_cells())
	pass
