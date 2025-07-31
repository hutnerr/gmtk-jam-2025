extends Control

@onready var quitButton: Button = $PanelContainer/MarginContainer/MainContainer/QuitButton
@onready var quitButtonSpacer: Control = $PanelContainer/MarginContainer/MainContainer/Spacer4
@onready var closeSettingsButton: Button = $PanelContainer/MarginContainer/MainContainer/CloseButton
@onready var mainMenuButton: Button = $PanelContainer/MarginContainer/MainContainer/MainMenuButton
@onready var mainMenuButtonSpacer: Control = $PanelContainer/MarginContainer/MainContainer/Spacer3
@onready var coveragePanel: Panel = $CoveragePanel # for in the main menu to hide 

const MAIN_PATH = "res://00_main/Main.tscn"

func _ready() -> void:
	toggleVisible()
	get_tree().paused = false # since toggleVis will pause us
	process_mode = Node.PROCESS_MODE_ALWAYS
	mainMenuButton.pressed.connect(onMainMenuButtonPressed)
	quitButton.pressed.connect(onQuitButtonPressed)
	closeSettingsButton.pressed.connect(onCloseSettingsButtonPressed)
	KeyboardDetector.escPressed.connect(onEscPressed)
	
func onEscPressed() -> void:
	toggleVisible()
	
func onMainMenuButtonPressed() -> void:
	toggleVisible()
	SceneTransitioner.change_scene(MAIN_PATH)
	coveragePanel.visible = true
	
func onQuitButtonPressed() -> void:
	get_tree().quit()
	
func onCloseSettingsButtonPressed() -> void:
	visible = false
	coveragePanel.visible = false
	get_tree().paused = false

func toggleVisible() -> void:
	var tree = get_tree()
	if tree.current_scene.scene_file_path == MAIN_PATH:
		mainMenuButton.visible = false
		mainMenuButtonSpacer.visible = false
		quitButton.visible = false
		quitButtonSpacer.visible = false
		coveragePanel.visible = true
	else:
		mainMenuButton.visible = true
		mainMenuButtonSpacer.visible = true
		quitButton.visible = true
		quitButtonSpacer.visible = true
		coveragePanel.visible = false
	
	tree.paused = !tree.paused
	visible = !visible 
