extends Node2D

var currentGrid: TileMap
var gridObjects: Dictionary

func _ready() -> void:
	reset()

func reset() -> void:
	currentGrid = null
	gridObjects = {}

func loadGridObject() -> void:
	# look through the current grid
	pass
