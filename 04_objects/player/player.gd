extends Node2D

var movementDistance

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred("anon")

func anon():
	movementDistance = Gridleton.currentGrid.tile_set.tile_size

func _process(delta: float) -> void:
	if not movementDistance:
		return
	
	var gridPos = Gridleton.currentGrid.local_to_map(global_position) # gives us the current pos on the grid
	var change = Vector2i(0, 0)
	if Input.is_action_just_pressed("right"):
		change = Vector2i(1, 0)
	elif Input.is_action_just_pressed("left"):
		change = Vector2i(-1, 0)
	elif Input.is_action_just_pressed("up"):
		change = Vector2i(0, -1)
	elif Input.is_action_just_pressed("down"):
		change = Vector2i(0, 1)
	else:
		change = Vector2i(0, 0)
		
	gridPos += change
	global_position = Gridleton.currentGrid.to_global(Gridleton.currentGrid.map_to_local(gridPos))
		
		# have global, transform into grid
		# perform movement
		# translate back
		
	
