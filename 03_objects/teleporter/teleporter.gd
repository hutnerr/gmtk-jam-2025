extends GridObject

var destination: GridObject # this will be set when reading in the nodes

func _ready() -> void:
	type = GridObject.ObjectType.TELEPORTER

func handleOverlap(overlappingObj: GridObject,  overlapCell: Vector2i):
	sendObjToDestination(overlappingObj)

func sendObjToDestination(overlappingObj: GridObject) -> void:
	pass
