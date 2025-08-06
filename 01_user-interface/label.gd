extends RichTextLabel

var cTween: Tween

func startCredits():
	cTween = create_tween()
	var endY = -get_content_height()
	cTween.tween_property(self, "position:y", endY, 20.0)
