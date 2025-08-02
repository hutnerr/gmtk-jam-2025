extends GridObject

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



func handleOverlap(overlappingObj: GridObject,  overlapCell: Vector2i) -> GridObject.ObjectType:
	# this will be called to determine behavior for going into a cell
	# that something else is already in
	match overlappingObj.type:
		GridObject.ObjectType.ENEMY:
			Gridleton.killEnemy(overlapCell)
		_:
			print("match failed")
	return overlappingObj.type
		
func takeTurn(command: BaseCommand, loopId: int = -1) -> void:
	var animStarterText = "Nonchalant Move "
	print("takeTurn called with loop ID: ", loopId, " current loop ID: ", Looper.currentLoopId)
	
	# Check if this turn belongs to a cancelled loop
	if loopId != -1 and Looper.currentLoopId != loopId:
		print("Turn cancelled - wrong loop ID")
		emit_signal("turnCompleted")
		return
	
	var newPosition: Vector2i = movementComponent.getNewPosition(command)
	var overlapObject = Gridleton.findGridObjectByPosition(newPosition)
	
	# Get the actual world direction for animation
	var actualDirection: Vector2i = movementComponent.transformDirection(command.direction)
	var directionString: String = movementComponent.directionToString(actualDirection)
	
	if Looper.looping and (loopId == -1 or Looper.currentLoopId == loopId) and overlapObject:
		var overlapObjName: GridObject.ObjectType = handleOverlap(overlapObject, newPosition)
		match overlapObjName:
			GridObject.ObjectType.ENEMY:
				animStarterText = "Move & Attack "
			GridObject.ObjectType.MOVING_ENEMY:
				animStarterText = "Move & Attack "
			GridObject.ObjectType.WALL:
				animStarterText = null
			GridObject.ObjectType.TELEPORTER:
				animStarterText = "Nonchalant Move "
	
	print(movementComponent.currentDirection)
	# v We hit a mfing wall v
	if animStarterText and not isAFuckinRotateThing(command):
		print("Starting 1 second wait for loop ID: ", loopId)
		
		# Use the actual world direction for animation
		animPlayer.play(animStarterText + directionString)
		await animPlayer.animation_finished
		print("Finished 1 second wait for loop ID: ", loopId)
	else:
		await get_tree().create_timer(0.01)
		
	# Final check before moving
	if Looper.looping and (loopId == -1 or Looper.currentLoopId == loopId):
		print("Moving player for loop ID: ", loopId)
		movementComponent.move(newPosition)
	else:
		print("NOT moving player - loop was cancelled. Loop ID: ", loopId, " Current: ", Looper.currentLoopId)
		
	emit_signal("turnCompleted")
func resetPosition() -> void:
	global_position = defaultPosition
	gridPos = Gridleton.globalPosToGridPos(global_position)

func isAFuckinRotateThing(command):
	return (command.cmdName == "Rotate270") or (command.cmdName == "Rotate180") or (command.cmdName == "Rotate90") 
	
	
func imBeingToldToStop():
	animPlayer.stop()
# looper gives next step
# take turn calls the step
# does the movement
# look at gridleton and figure out what we're going to collide with
# based on this colission, we do something
