class_name GridMovementComponent extends Node

var parent: GridObject
var currentDirection: Vector2i = Vector2i(1, 0)  # RIGHT by default

func _ready() -> void:
	parent = get_parent() as GridObject

func move(newPosition: Vector2i):
	parent.gridPos = newPosition
	parent.global_position = Gridleton.gridPosToGlobalPos(newPosition)
	
func getNewPosition(cmd: BaseCommand) -> Vector2i:
	if cmd.rotationDegrees != 0:
		currentDirection = rotateDirection(cmd.rotationDegrees)
		return parent.gridPos
	
	if cmd.direction != Vector2i.ZERO:
		var actualMovement = transformDirection(cmd.direction)
		return parent.gridPos + actualMovement
	
	return parent.gridPos

func getProperAnimDirection(direction: Vector2i) -> String:
	match direction:
		Vector2i(0, 1):
			return "Up"
		Vector2i(0, -1):
			return "Down"
		Vector2i(-1, 0):
			return "Left"
		Vector2i(1, 0):
			return "Right"
		_:
			return "Unknown"

func rotateDirection(degrees: int):
	match degrees:
		90:
			return Vector2i(currentDirection.y, -currentDirection.x)
		180:
			return Vector2i(-currentDirection.x, -currentDirection.y)
		270:
			return Vector2i(-currentDirection.y, currentDirection.x)
		_:
			return currentDirection

func transformDirection(commandDir: Vector2i) -> Vector2i:
	if commandDir == Vector2i(1, 0):  # FORWARD
		return currentDirection
	elif commandDir == Vector2i(-1, 0):  # BACKWARD
		return Vector2i(-currentDirection.x, -currentDirection.y)
	elif commandDir == Vector2i(0, -1):  # LEFT (relative to current direction)
		return Vector2i(-currentDirection.y, currentDirection.x)
	elif commandDir == Vector2i(0, 1):   # RIGHT (relative to current direction)
		return Vector2i(currentDirection.y, -currentDirection.x)
	return commandDir

func getCurrentGridPos() -> Vector2i:
	return Gridleton.currentGrid.local_to_map(parent.global_position)

func directionToString(dir: Vector2i) -> String:
	match dir:
		Vector2i(1, 0):
			return "Right"
		Vector2i(-1, 0):
			return "Left"
		Vector2i(0, -1):
			return "Up"
		Vector2i(0, 1):
			return "Down"
		_:
			return "UNKNOWN"
