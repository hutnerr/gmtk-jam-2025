extends Control

@onready var playButton: Button = $PanelContainer/VBoxContainer/ButtonMarginContainer/ButtonVBox/PlayButton
@onready var levelSelectButton: Button = $PanelContainer/VBoxContainer/ButtonMarginContainer/ButtonVBox/LevelSelButton
@onready var levelSelectMenu: Control = $LevelSelect
@onready var howToPlayButton: Button = $PanelContainer/VBoxContainer/ButtonMarginContainer/ButtonVBox/HowToPlayButton
@onready var settingsButton: Button = $PanelContainer/VBoxContainer/ButtonMarginContainer/ButtonVBox/SettingsButton
@onready var quitButton: Button = $PanelContainer/VBoxContainer/ButtonMarginContainer/ButtonVBox/QuitButton

const FIRST_LEVEL: String = "res://05_levels/1/Level1.tscn"
const HOW_TO_PLAY: String = "res://01_user-interface/how-to-play/HowToPlay.tscn"

func _ready() -> void:
	playButton.pressed.connect(onPlayButtonPressed)
	levelSelectButton.pressed.connect(onLevelSelectButtonButtonPressed)
	settingsButton.pressed.connect(onSettingsButtonButtonPressed)
	quitButton.pressed.connect(onQuitButtonPressed)
	howToPlayButton.pressed.connect(onHowToPlayButtonPressed)
	
func onPlayButtonPressed() -> void:
	levelSelectMenu.visible = false
	SceneTransitioner.change_scene(FIRST_LEVEL)

func onLevelSelectButtonButtonPressed() -> void:
	levelSelectMenu.visible = !levelSelectMenu.visible
	print("Level Select Button Pressed")

func onHowToPlayButtonPressed() -> void:
	levelSelectMenu.visible = false
	SceneTransitioner.change_scene(HOW_TO_PLAY)

func onSettingsButtonButtonPressed() -> void:
	levelSelectMenu.visible = false
	KeyboardDetector.escPressed.emit() # this is kinda monkey

func onQuitButtonPressed() -> void:
	get_tree().quit()
