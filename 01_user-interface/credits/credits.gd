extends Control

const MAIN_SCENE: String = "res://00_main/Main.tscn"

@onready var mainMenuButton: Button = $GoodBoyButton

func _ready() -> void:
	mainMenuButton.pressed.connect(onMainMenuButtonPressed)
	
func onMainMenuButtonPressed() -> void:
	SceneTransitioner.change_scene(MAIN_SCENE)
