extends ParallaxBackground

@export var scrollSpeed: Vector2 = Vector2(30, 0)

func _process(delta: float) -> void:
	scroll_offset += scrollSpeed * delta
