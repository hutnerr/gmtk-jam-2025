extends Node2D

signal allEnemiesKilled

var currentGrid: TileMapLayer
var gridObjects: Array[GridObject] # keep them in order to loop
var deadEnemies: Dictionary
var enemyCount: int = 0
var currentEnemies: int

func _ready() -> void:
	reset()

func killEnemy(overlapCell: Vector2i) -> void:
	var obj = findGridObjectByPosition(overlapCell)
	var objIndex = findIndexOfObject(obj)

	if overlapCell in deadEnemies:
		return

	deadEnemies[overlapCell] = obj
	#obj.visible = false
	currentEnemies -= 1
	print("Enemies Left: ", currentEnemies)
	if currentEnemies <= 0:
		Looper.stopLoop()
		allEnemiesKilled.emit()
	
func findGridObjectByPosition(checkPos: Vector2i) -> GridObject:
	for object: GridObject in gridObjects:
		var objPos = object.gridPos
		if objPos == checkPos:
			return object
	return null

func findIndexOfObject(obj: GridObject) -> int:
	for i in range(len(gridObjects)):
		if gridObjects[i] == obj:
			return i
	return -1
	
func loadGridObjects(objects: Array[Node]) -> void:
	gridObjects = []
	enemyCount = 0
	deadEnemies = {}

	for object: GridObject in objects:
		if object.type == GridObject.ObjectType.ENEMY or object.type == GridObject.ObjectType.MOVING_ENEMY:
			enemyCount += 1

		var gridPos = globalPosToGridPos(object.global_position)
		object.gridPos = gridPos
		object.global_position = gridPosToGlobalPos(gridPos)

		gridObjects.append(object)

	currentEnemies = enemyCount

func reloadGridObjects() -> void:
	# iter through dead enemies and make them visible again
	for enemy in deadEnemies.values():
		enemy.visible = true
	currentEnemies = enemyCount
	deadEnemies = {}

func reset() -> void:
	currentGrid = null
	gridObjects = []
	enemyCount = 0
	
func globalPosToGridPos(objPos: Vector2) -> Vector2i:
	if not objPos:
		print("u done super messed up")
		return Vector2i.ZERO
	return currentGrid.local_to_map(objPos)

func gridPosToGlobalPos(gridPos: Vector2i) -> Vector2:
	if not currentGrid:
		print("No current grid!")
		return Vector2.ZERO
	return currentGrid.to_global(currentGrid.map_to_local(gridPos))
	
