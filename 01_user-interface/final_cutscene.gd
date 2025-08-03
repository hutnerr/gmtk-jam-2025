extends Node2D

@onready var animPlayer = $AnimationPlayer
@onready var mainGuitarLoop = 	$"Guitar-mainloop"
func _ready() -> void:
	animPlayer.animation_finished.connect(onDonePlaying)
	mainGuitarLoop.finished.connect(replay)

func onDonePlaying(something) -> void:
	mainGuitarLoop.play()
	print("roll the fuckin credits baby")
	pass

func stfu() -> void:
	mainGuitarLoop.stop()

func replay() -> void:
	mainGuitarLoop.play()
