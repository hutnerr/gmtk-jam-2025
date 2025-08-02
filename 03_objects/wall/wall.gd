extends GridObject


@export var animName: String
@onready var animSprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	if not animName:
		var animList = animSprite.sprite_frames.get_animation_names()
		animName = animList[randi_range(0, len(animList) - 1)]
		pass
	type = GridObject.ObjectType.WALL
	animSprite.play(animName)

# doesn't have to do anything special, just act as a sentienl for determining
# othe node interaction behaviorr
