extends Node2D

var player
var defaultPosition: Vector2  # initial position of our player
var currentDirection: Vector2i = Vector2i(1, 0)  # RIGHT by default
var defaultDirection: Vector2i = Vector2i(1, 0)  # player initial direction facing

func move(cmd: BaseCommand):
	if not player:
		return
		
	if cmd.rotationDegrees != 0:
		rotateDirection(cmd.rotationDegrees)
		return
	
	if cmd.direction != Vector2i.ZERO:
		var actualMovement = transformDirection(cmd.direction)
		movePlayerOnGrid(actualMovement)

func rotateDirection(degrees: int):
	match degrees:
		90:
			# rotate 90 degrees clockwise: (x,y) -> (y,-x)
			currentDirection = Vector2i(currentDirection.y, -currentDirection.x)
		180:
			# rotate 180 degrees: (x,y) -> (-x,-y)
			currentDirection = Vector2i(-currentDirection.x, -currentDirection.y)
		270:
			# rotate 270 degrees clockwise: (x,y) -> (-y,x)
			currentDirection = Vector2i(-currentDirection.y, currentDirection.x)
	
	if player:
		rotatePlayerSprite()
	
	print("Rotated to face: ", directionToString(currentDirection))

func rotatePlayerSprite():
	if not player:
		return
	
	var sprite = player.get_node_or_null("Sprite2D")
	if not sprite:
		for child in player.get_children():
			if child is Sprite2D:
				sprite = child
				break
	
	if not sprite:
		print("no sprite found")
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
		_:
			print("Unknown direction: ", currentDirection)

func transformDirection(commandDir: Vector2i) -> Vector2i:
	# If the command is RIGHT (1,0), use current direction
	if commandDir == Vector2i(1, 0):
		return currentDirection
	
	# If the command is LEFT (-1,0), use opposite of current direction  
	elif commandDir == Vector2i(-1, 0):
		return Vector2i(-currentDirection.x, -currentDirection.y)
		
	# For UP/DOWN, we need to determine perpendicular directions
	elif commandDir == Vector2i(0, -1):  # UP
		return Vector2i(-currentDirection.y, currentDirection.x)
	elif commandDir == Vector2i(0, 1):   # DOWN
		return Vector2i(currentDirection.y, -currentDirection.x)
	
	return commandDir

func movePlayerOnGrid(movement: Vector2i):
	var currentGridPos = Gridleton.currentGrid.local_to_map(player.global_position)
	var newGridPos = currentGridPos + movement
	player.global_position = Gridleton.currentGrid.to_global(Gridleton.currentGrid.map_to_local(newGridPos))
	print("Moved to grid position: ", newGridPos)

func directionToString(dir: Vector2i) -> String:
	if dir == Vector2i(1, 0):
		return "RIGHT"
	elif dir == Vector2i(-1, 0):
		return "LEFT"
	elif dir == Vector2i(0, -1):
		return "UP"
	elif dir == Vector2i(0, 1):
		return "DOWN"
	return "UNKNOWN"

func convertPlayerGlobalToGrid() -> Vector2i:
	if not player:
		return Vector2i.ZERO
	return Gridleton.currentGrid.local_to_map(player.global_position)

func reset():
	if not player:
		return

	player.global_position = defaultPosition
	currentDirection = defaultDirection
	rotatePlayerSprite()
