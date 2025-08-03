class_name GridObject extends Node2D

signal overlapped
signal turnCompleted

enum ObjectType {
	PLAYER,
	WALL,
	ENEMY,
	MOVING_ENEMY,
	TELEPORTER,
	SCENE_TELEPORTER
}

var type: ObjectType
var gridPos: Vector2i

func handleOverlap(overlappingObj: GridObject, currentPosition: Vector2i, overlapCell: Vector2i) -> Vector2i:
	return Vector2i.ZERO

func takeTurn(command: BaseCommand):
	await get_tree().create_timer(0.05).timeout
	turnCompleted.emit()
