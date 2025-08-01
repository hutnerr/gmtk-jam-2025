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

# tells us grid overlap
# pass in a thing to check, and thing to look at, tells us if collission
# then calls object.handleColission()? or returns something

func handleGridOverlap(gridPosition) -> void:
	var gridObject: GridObject = gridObjects[gridPosition]
	gridObject.handleOverlap.call()
	
	if gridObject.type == GridObject.ObjectType.ENEMY:
		# FIXME: kill anim here
		slainEnemies[gridPosition] = gridObject # store it
		gridObjects.erase(gridObject) # remove it
		gridObject.visible = false
		enemyCount -= 1
		if enemyCount <= 0:
			Looper.looping = false
			allEnemiesKilled.emit()

# change how killing things work
# signal connect to keep track of how many enemies died?
# this would have to store the original loaded and then repopulate them
# cause we're klilling theyu ass
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
	
	
# conversion methods like global pos to grid pos?
# static methods
