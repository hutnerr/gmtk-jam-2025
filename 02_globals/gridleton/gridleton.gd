extends Node2D

signal loaded
signal allEnemiesKilled

var currentGrid: TileMapLayer
var gridObjects: Dictionary
var enemyCount: int = 0
var slainEnemies: Dictionary
var initObjects

func _ready() -> void:
	reset()
	
func reset() -> void:
	currentGrid = null
	gridObjects = {}

func handleGridOverlap(gridPosition) -> void:
	var gridObject: GridObject = gridObjects[gridPosition]
	
	if gridObject.type == GridObject.ObjectType.ENEMY:
		slainEnemies[gridPosition] = gridObject # store it
		gridObjects.erase(gridObject) # remove it
		gridObject.visible = false
		enemyCount -= 1
		if enemyCount <= 0:
			Looper.looping = false
			allEnemiesKilled.emit()

func resetGridObjects() -> void:
	for deadEnemyLoc in slainEnemies:
		gridObjects[deadEnemyLoc] = slainEnemies[deadEnemyLoc]
		enemyCount += 1
	
	for object in gridObjects.values():
		object.visible = true
	
func loadGridObjects(objects) -> void:
	enemyCount = 0
	gridObjects = {}
	
	for object: GridObject in objects:
		if object.type == GridObject.ObjectType.ENEMY:
			enemyCount += 1
		
		var objpos = object.global_position
		var converted = currentGrid.local_to_map(objpos)
		object.global_position = currentGrid.to_global(currentGrid.map_to_local(converted)) # center in cell
		gridObjects[converted] = object
	loaded.emit()
	print(gridObjects)
