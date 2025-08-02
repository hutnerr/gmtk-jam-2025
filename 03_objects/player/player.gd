extends GridObject

@onready var animPlayer: AnimationPlayer = $Animations

var defaultPosition
var movementDistance
@onready var movementComponent: GridMovementComponent = $GridMovementComponent
@onready var arrowDistance = 25
@onready var arrow: Sprite2D = $Arrow

func _ready() -> void:
	self.type = ObjectType.PLAYER
	self.defaultPosition = global_position
	arrow.position = Vector2(arrowDistance, 0)
	call_deferred("getMovementDistance")

func getMovementDistance():
	movementDistance = Gridleton.currentGrid.tile_set.tile_size

func handleOverlap(overlappingObj: GridObject, currentPosition: Vector2i, overlapCell: Vector2i) -> Vector2i:
	match overlappingObj.type:
		GridObject.ObjectType.ENEMY:
			# Check if enemy is already dead
			if overlapCell in Gridleton.deadEnemies:
				return overlapCell  # Move through dead enemy normally
			else:
				var success = Gridleton.killEnemy(overlapCell)
				if success:
					return overlapCell  # Successfully killed, move to cell
				else:
					return currentPosition  # Failed to kill (shouldn't happen?)
		GridObject.ObjectType.WALL:
			return currentPosition # stay where we are
		GridObject.ObjectType.TELEPORTER:
			return overlappingObj.destination.gridPos
		_:
			return currentPosition # stay where we are if all fails

func takeTurn(command: BaseCommand, loopId: int = -1) -> void:
	var animStarterText = "Nonchalant Move "
	
	# Check if this turn belongs to a cancelled loop
	if loopId != -1 and Looper.currentLoopId != loopId:
		print("Turn cancelled - wrong loop ID")
		emit_signal("turnCompleted")
		return
		
	var newPosition: Vector2i = movementComponent.getNewPosition(command)
	var overlapObject = Gridleton.findGridObjectByPosition(newPosition)
	
	# Get the actual world direction for animation
	var currentPosition: Vector2i = gridPos
	var actualDirection: Vector2i = movementComponent.transformDirection(command.direction)
	var directionString: String = movementComponent.directionToString(actualDirection)
	
	var playPortal = false
	var overlapNewPosition: Vector2i = newPosition
	if Looper.looping and (loopId == -1 or Looper.currentLoopId == loopId) and overlapObject:
		
		# Check enemy state BEFORE calling handleOverlap
		var enemyAlreadyDead = false
		if overlapObject.type == GridObject.ObjectType.ENEMY:
			enemyAlreadyDead = newPosition in Gridleton.deadEnemies
		
		# Now handle the overlap (which might kill the enemy)
		overlapNewPosition = handleOverlap(overlapObject, currentPosition, newPosition)
		
		
		match overlapObject.type:
			GridObject.ObjectType.ENEMY:
				if enemyAlreadyDead:
					animStarterText = "Nonchalant Move "  # Enemy was already dead
				else:
					animStarterText = "Move & Attack "  # Enemy was alive, we attacked it
			GridObject.ObjectType.WALL:
				animStarterText = null
			GridObject.ObjectType.TELEPORTER:
				playPortal = true
				animStarterText = "Nonchalant Move "
	
	if animStarterText and not isAFuckinRotateThing(command):		
		animPlayer.play(animStarterText + directionString)
		await animPlayer.animation_finished
		if playPortal:
			AudiManny.playPortalSFX()
	else:
		animPlayer.play("Searching")
		await animPlayer.animation_finished
		
	if Looper.looping and (loopId == -1 or Looper.currentLoopId == loopId):
		movementComponent.move(overlapNewPosition)

		var direction_vector = Vector2(movementComponent.currentDirection)
		arrow.position = direction_vector.normalized() * arrowDistance
		arrow.rotation = direction_vector.angle()
		
	emit_signal("turnCompleted")

func resetPosition() -> void:
	global_position = defaultPosition
	gridPos = Gridleton.globalPosToGridPos(global_position)

func isAFuckinRotateThing(command):
	#return command.rotation != 0
	return (command.cmdName == "Rotate270") or (command.cmdName == "Rotate180") or (command.cmdName == "Rotate90") 
	
func imBeingToldToStop():
	animPlayer.stop()
	animPlayer.play("RESET")
	movementComponent.currentDirection = Vector2i(1, 0)
# looper gives next step
# take turn calls the step
# does the movement
# look at gridleton and figure out what we're going to collide with
# based on this colission, we do something
