extends GridObject

@export var path: String = "res://01_user-interface/FinalCutscene.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	type = ObjectType.SCENE_TELEPORTER
