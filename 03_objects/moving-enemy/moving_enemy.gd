extends GridObject

var movementPattern # unsure how to get this to work. 

func _ready() -> void:
	type = GridObject.ObjectType.MOVING_ENEMY

func takeTurn(command: BaseCommand):
	print("Moving enemy taking it's turn")
	# dont use the newPosition, thats there for the player
	# use the predefined movement pattern
