extends Control

@onready var playButton: Button = $PanelContainer/VBoxContainer/ButtonMarginContainer/ButtonVBox/PlayButton
@onready var levelSelectButton: Button = $PanelContainer/VBoxContainer/ButtonMarginContainer/ButtonVBox/LevelSelButton
@onready var levelSelectMenu: Control = $LevelSelect
@onready var howToPlayButton: Button = $PanelContainer/VBoxContainer/ButtonMarginContainer/ButtonVBox/HowToPlayButton
@onready var settingsButton: Button = $PanelContainer/VBoxContainer/ButtonMarginContainer/ButtonVBox/SettingsButton
@onready var quitButton: Button = $PanelContainer/VBoxContainer/ButtonMarginContainer/ButtonVBox/QuitButton
@onready var creditsButton: Button = $PanelContainer/VBoxContainer/ButtonMarginContainer/ButtonVBox/CreditsButton

const FIRST_LEVEL: String = "res://05_levels/1/Level1.tscn"
const HOW_TO_PLAY: String = "res://01_user-interface/how-to-play/HowToPlay.tscn"
const CREDITS: String = "res://01_user-interface/credits/Credits.tscn"

func _ready() -> void:
	playButton.pressed.connect(onPlayButtonPressed)
	levelSelectButton.pressed.connect(onLevelSelectButtonButtonPressed)
	settingsButton.pressed.connect(onSettingsButtonButtonPressed)
	quitButton.pressed.connect(onQuitButtonPressed)
	howToPlayButton.pressed.connect(onHowToPlayButtonPressed)
	creditsButton.pressed.connect(onCreditsButtonPressed)
	
func onPlayButtonPressed() -> void:
	levelSelectMenu.visible = false
	SceneTransitioner.change_scene(FIRST_LEVEL)
	AudiManny.playLevelMusic()

func onLevelSelectButtonButtonPressed() -> void:
	levelSelectMenu.visible = !levelSelectMenu.visible

func onHowToPlayButtonPressed() -> void:
	levelSelectMenu.visible = false
	SceneTransitioner.change_scene(HOW_TO_PLAY)

func onSettingsButtonButtonPressed() -> void:
	levelSelectMenu.visible = false
	SettingsMenu.get_child(0).toggleMenu()

func onQuitButtonPressed() -> void:
	get_tree().quit()

func onCreditsButtonPressed() -> void:
	SceneTransitioner.change_scene(CREDITS)
