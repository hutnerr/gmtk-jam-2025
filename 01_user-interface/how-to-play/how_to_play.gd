extends Control

const MAIN_MENU = "res://00_main/Main.tscn"

@onready var goodBoyButton: Button = $Panel/GoodBoyButton

func _ready() -> void:
	goodBoyButton.pressed.connect(onGoodBoyButtonPressed)

func onGoodBoyButtonPressed() -> void:
	SceneTransitioner.change_scene(MAIN_MENU)
