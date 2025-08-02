extends GridObject

var destination: GridObject # this will be set when reading in the nodes

func _ready() -> void:
	type = GridObject.ObjectType.TELEPORTER

func handleOverlap(overlappingObj: GridObject, currentPosition: Vector2i, overlapCell: Vector2i) -> Vector2i:
	sendObjToDestination(overlappingObj)
	return Vector2i.ZERO

func sendObjToDestination(overlappingObj: GridObject) -> void:
	pass
