class_name GridMovementComponent extends Node

var parent: GridObject
var currentDirection: Vector2i = Vector2i(1, 0)  # RIGHT by default

func _ready() -> void:
	parent = get_parent() as GridObject

func move(newPosition: Vector2i):
	parent.gridPos = newPosition  # Update the GridObject's grid position
	parent.global_position = Gridleton.gridPosToGlobalPos(newPosition)
	
func getNewPosition(cmd: BaseCommand) -> Vector2i:
	# Rotation commands don't change position, just direction
	if cmd.rotationDegrees != 0:
		rotateDirection(cmd.rotationDegrees)
		return parent.gridPos  # Return current position (no movement)
	
	# Movement commands calculate new position
	if cmd.direction != Vector2i.ZERO:
		var actualMovement = transformDirection(cmd.direction)
		return parent.gridPos + actualMovement
	
	return parent.gridPos

func rotateDirection(degrees: int):
	match degrees:
		90:
			currentDirection = Vector2i(currentDirection.y, -currentDirection.x)
		180:
			currentDirection = Vector2i(-currentDirection.x, -currentDirection.y)
		270:
			currentDirection = Vector2i(-currentDirection.y, currentDirection.x)
		_:
			pass  # Handle unknown rotation values
	
	# Optional: Handle sprite rotation here if needed
	rotateSprite()

func rotateSprite():
	# Find and rotate the sprite (similar to your original rotatePlayerSprite)
	var sprite = parent.get_node_or_null("Sprite2D")
	if not sprite:
		for child in parent.get_children():
			if child is Sprite2D:
				sprite = child
				break
	
	if not sprite:
		return
	
	match currentDirection:
		Vector2i(1, 0):   # RIGHT
			sprite.rotation_degrees = 0
		Vector2i(0, 1):   # DOWN
			sprite.rotation_degrees = 90
		Vector2i(-1, 0):  # LEFT
			sprite.rotation_degrees = 180
		Vector2i(0, -1):  # UP
			sprite.rotation_degrees = 270

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
			return "RIGHT"
		Vector2i(-1, 0):
			return "LEFT"
		Vector2i(0, -1):
			return "UP"
		Vector2i(0, 1):
			return "DOWN"
		_:
			return "UNKNOWN"
