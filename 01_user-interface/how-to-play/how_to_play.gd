extends Control

const MAIN_MENU = "res://00_main/Main.tscn"
const LEVEL_ONE = "res://05_levels/Level1.tscn"

@onready var goodBoyButton: Button = $VBoxContainer/HBoxContainer/MarginContainer2/VBoxContainer/MarginContainer/VBoxContainer/GoodBoyButton
@onready var levelOneButton: Button = $VBoxContainer/HBoxContainer/MarginContainer2/VBoxContainer/MarginContainer/VBoxContainer/LevelOneButton

func _ready() -> void:
	goodBoyButton.pressed.connect(onGoodBoyButtonPressed)
	levelOneButton.pressed.connect(onLevelOneButtonPressed)

func onGoodBoyButtonPressed() -> void:
	SceneTransitioner.change_scene(MAIN_MENU)

func onLevelOneButtonPressed() -> void:
	SceneTransitioner.change_scene(LEVEL_ONE)
	AudiManny.playLevelMusic()
