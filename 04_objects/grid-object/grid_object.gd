class_name GridObject extends Node2D

enum ObjectType {
	PLAYER,
	ENEMY,
	WALL
}

signal overlapped

@export var type: ObjectType
# sprite / animated sprite export

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
