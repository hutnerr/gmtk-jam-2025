extends GridObject

@onready var animPlayer: AnimationPlayer = $Animations

var defaultPosition
var movementDistance
@onready var movementComponent: GridMovementComponent = get_node("GridMovementComponent")

func _ready() -> void:
	self.type = ObjectType.PLAYER
	self.defaultPosition = global_position
	call_deferred("getMovementDistance")

func getMovementDistance():
	movementDistance = Gridleton.currentGrid.tile_set.tile_size

func handleOverlap(overlappingObj: GridObject,  overlapCell: Vector2i):
	# this will be called to determine behavior for going into a cell
	# that something else is already in
	match overlappingObj.type:
		GridObject.ObjectType.ENEMY:
			Gridleton.killEnemy(overlapCell)
		_:
			print("match failed")

func takeTurn(command: BaseCommand):
	var newPosition: Vector2i = movementComponent.getNewPosition(command) # gets the new grid pos
	var overlapObject = Gridleton.findGridObjectByPosition(newPosition)
	if overlapObject:
		handleOverlap(overlapObject, newPosition)
	
	movementComponent.move(newPosition) # call the actual move 
	turnCompleted.emit()

func resetPosition() -> void:
	global_position = defaultPosition
	gridPos = Gridleton.globalPosToGridPos(global_position)

# looper gives next step
# take turn calls the step
# does the movement
# look at gridleton and figure out what we're going to collide with
# based on this colission, we do something
