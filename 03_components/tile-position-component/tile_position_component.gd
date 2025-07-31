class_name TilePositionComponent extends Node

var parent: Node2D
var loc: Vector2

func _ready() -> void:
	parent = get_parent()
	call_deferred("anon")

	

func anon():
	loc = Gridleton.currentGrid.local_to_map(parent.global_position)
	Gridleton.gridObjects[loc] = parent
	print(loc)
