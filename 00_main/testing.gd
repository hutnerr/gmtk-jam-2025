extends ParallaxBackground

var scroll_speed := Vector2(30, 0) # Adjust as needed

func _process(delta: float) -> void:
	scroll_offset += scroll_speed * delta
