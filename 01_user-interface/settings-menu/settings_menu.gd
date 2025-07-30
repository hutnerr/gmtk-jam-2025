extends Control

@onready var quitButton: Button = $PanelContainer/MarginContainer/MainContainer/QuitButton
@onready var quitButtonSpacer: Control = $PanelContainer/MarginContainer/MainContainer/Spacer4
@onready var closeSettingsButton: Button = $PanelContainer/MarginContainer/MainContainer/CloseButton
@onready var mainMenuButton: Button = $PanelContainer/MarginContainer/MainContainer/MainMenuButton
@onready var mainMenuButtonSpacer: Control = $PanelContainer/MarginContainer/MainContainer/Spacer3
@onready var coveragePanel: Panel = $CoveragePanel # for in the main menu to hide 

func _ready() -> void:
	mainMenuButton.pressed.connect(onMainMenuButtonPressed)
	quitButton.pressed.connect(onQuitButtonPressed)
	closeSettingsButton.pressed.connect(onCloseSettingsButtonPressed)
	KeyboardDetector.escPressed.connect(onEscPressed)
	
func onEscPressed() -> void:
	toggleVisible()
	
func onMainMenuButtonPressed() -> void:
	print("Main Menu Button Pressed")
	# either change scene or change visibility of some stuff
	# depending on how we implement it
	
func onQuitButtonPressed() -> void:
	get_tree().quit()
	
func onCloseSettingsButtonPressed() -> void:
	visible = false
	get_tree().paused = false

func toggleVisible() -> void:
	var tree = get_tree()
	if tree.current_scene.scene_file_path == "res://00_main/Main.tscn":
		mainMenuButton.visible = false
		mainMenuButtonSpacer.visible = false
		quitButton.visible = false
		quitButtonSpacer.visible = false
		if !visible: # since we're about to change this, check the inverse
			coveragePanel.visible = true
	
	tree.paused = !tree.paused
	visible = !visible 
