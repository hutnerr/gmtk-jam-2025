extends Control

signal mainMenuButtonRequest

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

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		toggleMenu()

func toggleMenu() -> void:
	if visible:
		AudiManny.playPressSFX()
	else:
		AudiManny.playHoverSFX()
	toggleVisible()

func onMainMenuButtonPressed() -> void:
	toggleVisible()
	mainMenuButtonRequest.emit()
	SceneTransitioner.change_scene(MAIN_PATH)
	# FIXME: clean up this shite 
	#AudiManny.playMenuMusic()
	Looper.stopLoop()
	Looper.clearCommands()
	
func onQuitButtonPressed() -> void:
	get_tree().quit()
	
func onCloseSettingsButtonPressed() -> void:
	visible = false
	get_tree().paused = false

func toggleVisible() -> void:
	var tree = get_tree()
	if tree.current_scene.scene_file_path == MAIN_PATH:
		mainMenuButton.visible = false
		mainMenuButtonSpacer.visible = false
		quitButton.visible = false
		quitButtonSpacer.visible = false
	else:
		mainMenuButton.visible = true
		mainMenuButtonSpacer.visible = true
		quitButton.visible = true
		quitButtonSpacer.visible = true
	
	tree.paused = !tree.paused
	visible = !visible 
