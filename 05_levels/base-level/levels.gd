extends Node

@onready var gridTile = $Grid
@export var gameObjects: Node

@export var loopLimit: int = 10
@export var levelString: String = "NOTSET"
@export var levelNum: int = -1

func _ready():
	Gridleton.currentGrid = gridTile
	call_deferred("defer")

# let the game objects load before loading th em into Gridleton
func defer() -> void:
	var gridObjects = gameObjects.get_children()
	Gridleton.loadGridObjects(gridObjects)
