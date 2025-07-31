extends Node


@onready var gridTile = $GridTileMap
@onready var gameObjects = $GameObjects

func _ready():
	Gridleton.currentGrid = gridTile
	Gridleton.loadGridObjects(gameObjects.get_children())
