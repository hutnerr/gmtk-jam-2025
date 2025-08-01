class_name GridObject extends Node2D

signal overlapped

enum ObjectType {
	PLAYER,
	WALL,
	ENEMY, # maybe rename to STATIC_ENEMY
	MOVING_ENEMY,
	TELEPORTER,
}

@export var type: ObjectType

var handleOverlap: Callable

func _ready() -> void:
	handleOverlap = determineOverlapMethod()

func determineOverlapMethod() -> Callable:
	match type:
		ObjectType.ENEMY:
			return enemyOverlap
		ObjectType.WALL:
			return useless
		_:
			return useless

func enemyOverlap() -> void:
	print("ENEMY OVERLAP")
	overlapped.emit()

func useless() -> void:
	pass
