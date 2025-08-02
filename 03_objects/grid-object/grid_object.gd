class_name GridObject extends Node2D

signal overlapped
signal turnCompleted

enum ObjectType {
	PLAYER,
	WALL,
	ENEMY,
	MOVING_ENEMY,
	TELEPORTER,
}

var type: ObjectType
var gridPos: Vector2i

func handleOverlap(overlappingObj: GridObject,  overlapCell: Vector2i):
	pass

func takeTurn(command: BaseCommand):
	turnCompleted.emit()
