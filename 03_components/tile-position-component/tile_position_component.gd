class_name TilePositionComponent extends Node

var parent: Node2D

func _ready() -> void:
	parent = get_parent()
	print(Gridleton.currentGrid.to_local(parent.global_position))
