extends GridObject

@export var animName: String = "tree"
@onready var animSprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	type = GridObject.ObjectType.WALL
	animSprite.play(animName)

# doesn't have to do anything special, just act as a sentienl for determining
# othe node interaction behaviorr
