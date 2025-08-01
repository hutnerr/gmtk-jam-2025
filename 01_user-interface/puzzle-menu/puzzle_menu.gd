extends Control

@onready var playButton: Button = $MarginContainer/BaseContainer/PlayStopMargin/PlayStopButtons/PlayButton
@onready var stopButton: Button = $MarginContainer/BaseContainer/PlayStopMargin/PlayStopButtons/StopButton

@onready var clearLoopButton: Button = $MarginContainer/BaseContainer/MarginContainer/Panel/PrimaryContainer/ClearBtnMargin/ClearButton

@onready var upButton: Button = $MarginContainer/BaseContainer/MarginContainer/Panel/PrimaryContainer/CommandMargin/CommandItems/Up/UpButton
@onready var leftButton: Button = $MarginContainer/BaseContainer/MarginContainer/Panel/PrimaryContainer/CommandMargin/CommandItems/LeftRight/LeftButton
@onready var rightButton: Button = $MarginContainer/BaseContainer/MarginContainer/Panel/PrimaryContainer/CommandMargin/CommandItems/LeftRight/RightButton
@onready var downButton: Button = $MarginContainer/BaseContainer/MarginContainer/Panel/PrimaryContainer/CommandMargin/CommandItems/Down/DownButton
@onready var rotate90Button: Button = $MarginContainer/BaseContainer/MarginContainer/Panel/PrimaryContainer/CommandMargin/CommandItems/Rotations/R90Button
@onready var rotate180Button: Button = $MarginContainer/BaseContainer/MarginContainer/Panel/PrimaryContainer/CommandMargin/CommandItems/Rotations/R180Button
@onready var rotate270Button: Button = $MarginContainer/BaseContainer/MarginContainer/Panel/PrimaryContainer/CommandMargin/CommandItems/Rotations/R270Button

@onready var loopItemContainer: VBoxContainer = $MarginContainer/BaseContainer/MarginContainer/Panel/PrimaryContainer/LoopItemMargin/LoopItems

@onready var levelInfoLabel: Label = $MarginContainer/BaseContainer/MarginContainer/Panel/PrimaryContainer/InfoMargin/InformationContainer/LevelLabel
@onready var loopLimitLabel: Label = $MarginContainer/BaseContainer/MarginContainer/Panel/PrimaryContainer/InfoMargin/InformationContainer/LimitLabel

func _ready() -> void:
	playButton.pressed.connect(onPlayButtonPressed)
	rightButton.pressed.connect(onRightButtonPressed)
	leftButton.pressed.connect(onLeftButtonPressed)
	upButton.pressed.connect(onUpButtonPressed)
	downButton.pressed.connect(onDownButtonPressed)
	rotate90Button.pressed.connect(onRotate90ButtonPressed)
	rotate180Button.pressed.connect(onRotate180ButtonPressed)
	rotate270Button.pressed.connect(onRotate270ButtonPressed)
	clearLoopButton.pressed.connect(onClearLoopButtonPressed)
	stopButton.pressed.connect(onStopButtonPressed)
	
	# FIXME: Store this in the level object
	# still have to get tree get current scene
	# other way would be set a variable 
	var level = get_tree().current_scene.name.split("Level")[-1]
	levelInfoLabel.text += level
	Looper.loadNewLevel(level)
	loopLimitLabel.text += str(Looper.levelLimit)

func _process(delta: float) -> void:
	var currentCommands = Looper.commands
	if not currentCommands or len(currentCommands) <= 0:
		return
	renderCurrentCommands(currentCommands)
		
func emptyLoopItemContainer() -> void:
	for child in loopItemContainer.get_children():
		child.queue_free()

func renderCurrentCommands(cmds: Array[BaseCommand]) -> void:
	emptyLoopItemContainer()
	for i in range(len(cmds)):
		var cmd = cmds[i]
		if cmd:
			renderCommand(cmd, i)

func renderCommand(cmd: BaseCommand, index: int) -> void:
	var label = Label.new()
	label.add_theme_font_size_override("font_size", 16)
	if index == Looper.currentCommand:
		label.add_theme_color_override("font_color", Color("898d8a"))
	
	label.text = str(index + 1, ": ", cmd.cmdName)
	loopItemContainer.add_child(label)

func onPlayButtonPressed() -> void:
	Looper.runLoop()
	
func onRightButtonPressed() -> void:
	var cmd = BaseCommand.createCommand(BaseCommand.Commands.RIGHT)
	Looper.appendCommand(cmd)

func onLeftButtonPressed() -> void:
	var cmd = BaseCommand.createCommand(BaseCommand.Commands.LEFT)
	Looper.appendCommand(cmd)

func onUpButtonPressed() -> void:
	var cmd = BaseCommand.createCommand(BaseCommand.Commands.UP)
	Looper.appendCommand(cmd)
	
func onDownButtonPressed() -> void:
	var cmd = BaseCommand.createCommand(BaseCommand.Commands.DOWN)
	Looper.appendCommand(cmd)
	
func onRotate90ButtonPressed() -> void:
	var cmd = BaseCommand.createCommand(BaseCommand.Commands.ROTATE90)
	Looper.appendCommand(cmd)
	
func onRotate180ButtonPressed() -> void:
	var cmd = BaseCommand.createCommand(BaseCommand.Commands.ROTATE180)
	Looper.appendCommand(cmd)
	
func onRotate270ButtonPressed() -> void:
	var cmd = BaseCommand.createCommand(BaseCommand.Commands.ROTATE270)
	Looper.appendCommand(cmd)

func onClearLoopButtonPressed() -> void:
	Looper.looping = false
	Looper.currentCommand = null
	Looper.clearCommands()
	Gridleton.resetGridObjects()
	MoveManny.reset()
	emptyLoopItemContainer()

func onStopButtonPressed() -> void:
	Looper.looping = false
	Looper.currentCommand = null
	Gridleton.resetGridObjects()
	MoveManny.reset()
