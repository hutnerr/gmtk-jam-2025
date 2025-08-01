extends GridObject

@onready var animPlayer: AnimationPlayer = $Animations

var movementDistance

func _ready() -> void:
	MoveManny.player = self
	MoveManny.defaultPosition = self.global_position
	call_deferred("getMovementDistance")

func getMovementDistance():
	movementDistance = Gridleton.currentGrid.tile_set.tile_size

# looper gives next step
# take turn calls the step
# does the movement
# look at gridleton and figure out what we're going to collide with
# based on this colission, we do something
