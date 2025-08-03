extends GridObject

signal rotatedDirection(rotationDeg: int)

@onready var animPlayer: AnimationPlayer = $Animations

var defaultPosition
var movementDistance
@onready var movementComponent: GridMovementComponent = $GridMovementComponent

func _ready() -> void:
	self.type = ObjectType.PLAYER
	self.defaultPosition = global_position
	call_deferred("getMovementDistance")

func getMovementDistance():
	movementDistance = Gridleton.currentGrid.tile_set.tile_size

func handleOverlap(overlappingObj: GridObject, currentPosition: Vector2i, overlapCell: Vector2i) -> Vector2i:
	match overlappingObj.type:
		GridObject.ObjectType.ENEMY:
			if overlapCell in Gridleton.deadEnemies:
				return overlapCell
			else:
				var success = Gridleton.killEnemy(overlapCell)
				if success:
					return overlapCell 
				else:
					return currentPosition
		GridObject.ObjectType.WALL:
			return currentPosition # stay where we are
		GridObject.ObjectType.TELEPORTER:
			return overlappingObj.destination.gridPos
		GridObject.ObjectType.SCENE_TELEPORTER:
			print("we want to change this mf scene")
			SceneTransitioner.change_scene(overlappingObj.path)
			return Vector2i.ZERO
		_:
			return currentPosition # stay where we are if all fails

func takeTurn(command: BaseCommand, loopId: int = -1) -> void:
	var animStarterText = "Nonchalant Move "
		
	if loopId != -1 and Looper.currentLoopId != loopId:
		print("Turn cancelled - wrong loop ID")
		emit_signal("turnCompleted")
		return
		
	var newPosition: Vector2i = movementComponent.getNewPosition(command)
	
	# then we've rotated at this point in time, therefore emit the signal with
	# the integer of rotation that we've done
	if command.rotationDegrees != 0:
		rotatedDirection.emit(command.rotationDegrees)
	
	var overlapObject = Gridleton.findGridObjectByPosition(newPosition)
	
	var currentPosition: Vector2i = gridPos
	var actualDirection: Vector2i = movementComponent.transformDirection(command.direction)
	var directionString: String = movementComponent.directionToString(actualDirection)
	
	var playPortal = false
	var playHitWall = false
	var playKilledEnemy = false
	var overlapNewPosition: Vector2i = newPosition
	if Looper.looping and (loopId == -1 or Looper.currentLoopId == loopId) and overlapObject:
		
		var enemyAlreadyDead = false
		if overlapObject.type == GridObject.ObjectType.ENEMY:
			enemyAlreadyDead = newPosition in Gridleton.deadEnemies
		
		overlapNewPosition = handleOverlap(overlapObject, currentPosition, newPosition)
		
		match overlapObject.type:
			GridObject.ObjectType.ENEMY:
				if enemyAlreadyDead:
					animStarterText = "Nonchalant Move "
				else:
					animStarterText = "Move & Attack "
					playKilledEnemy = true
			GridObject.ObjectType.WALL:
				animStarterText = null
				playHitWall = true
			GridObject.ObjectType.TELEPORTER:
				playPortal = true
				animStarterText = "Nonchalant Move "
	
	if animStarterText and not isAFuckinRotateThing(command):
		animPlayer.play(animStarterText + directionString)
		#if playKilledEnemy:
			#AudiManny.playEnemyDeadSFX()
		await animPlayer.animation_finished
		if playPortal:
			AudiManny.playPortalSFX()

	else:
		if playHitWall:
			AudiManny.playWallHitSFX()
		animPlayer.play("Searching")
		await animPlayer.animation_finished
		
	if Looper.looping and (loopId == -1 or Looper.currentLoopId == loopId):
		movementComponent.move(overlapNewPosition)
		
	emit_signal("turnCompleted")

func resetPosition() -> void:
	global_position = defaultPosition
	gridPos = Gridleton.globalPosToGridPos(global_position)

func isAFuckinRotateThing(command):
	#return command.rotation != 0
	return (command.cmdName == "Rotate270") or (command.cmdName == "Rotate180") or (command.cmdName == "Rotate90") 
	
func playMyIdle():
	$AnimatedSprite2D.play("idleLantern")
	
func imBeingToldToStop():
	animPlayer.play("RESET")
	movementComponent.currentDirection = Vector2i(1, 0)
