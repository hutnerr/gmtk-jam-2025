extends Node


@onready var gridTile = $GridTileMap

func _ready():
	Gridleton.currentGrid = gridTile
	Gridleton.loadGridObject()
