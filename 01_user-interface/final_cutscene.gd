extends Node2D

@onready var animPlayer = $AnimationPlayer

func _ready() -> void:
	animPlayer.animation_finished.connect(onDonePlaying)

func onDonePlaying(something) -> void:
	print("roll the fuckin credits baby")
	pass
