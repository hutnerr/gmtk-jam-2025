extends RichTextLabel

var cTween: Tween

func startCredits():
	# Create tween
	cTween = create_tween()
	
	# Calculate end position
	var endY = -get_content_height()
	
	# Animate from current position
	cTween.tween_property(self, "position:y", endY, 20.0)
	cTween.tween_callback(creditsFinished)

func creditsFinished():
	print("Credits finished!")
