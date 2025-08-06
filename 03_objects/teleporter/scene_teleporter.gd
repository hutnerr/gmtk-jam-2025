extends GridObject

@export var path: String = "res://01_user-interface/FinalCutscene.tscn"

func _ready() -> void:
	type = ObjectType.SCENE_TELEPORTER
