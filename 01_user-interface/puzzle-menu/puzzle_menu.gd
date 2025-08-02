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

@onready var commandButtonMap := {
	rightButton: BaseCommand.Commands.RIGHT,
	leftButton: BaseCommand.Commands.LEFT,
	upButton: BaseCommand.Commands.UP,
	downButton: BaseCommand.Commands.DOWN,
	rotate90Button: BaseCommand.Commands.ROTATE90,
	rotate180Button: BaseCommand.Commands.ROTATE180,
	rotate270Button: BaseCommand.Commands.ROTATE270
}

func _ready() -> void:
	playButton.pressed.connect(onPlayButtonPressed)
	stopButton.pressed.connect(onStopButtonPressed)
	clearLoopButton.pressed.connect(onClearLoopButtonPressed)

	for button in commandButtonMap.keys():
		button.pressed.connect(onCommandButtonPressed.bind(commandButtonMap[button]))

	var level = get_tree().current_scene.get_node("BaseLevel")
	levelInfoLabel.text += level.levelString
	loopLimitLabel.text += str(level.loopLimit)
	Looper.loadNewLevel(level.loopLimit)

func onCommandButtonPressed(command: BaseCommand.Commands) -> void:
	var cmd: BaseCommand = BaseCommand.createCommand(command)
	var added = Looper.appendCommand(cmd)
	if added:
		renderCommand(cmd)

func renderCommand(cmd: BaseCommand) -> void:
	var label = Label.new()
	label.add_theme_font_size_override("font_size", 16)
	var index = Looper.getCommandIndex(cmd)
	label.text = str(index + 1, ": ", cmd.cmdName)
	loopItemContainer.add_child(label)

func highlightActiveCommand() -> void:
	# get the active command and make it grey
	# label.add_theme_color_override("font_color", Color("898d8a"))
	# have to store the last one and make it not grey at the same time
	pass

func onPlayButtonPressed() -> void:
	if Looper.startable:
		Looper.runLoop()
	else:
		print("not right now lil bro")

func onClearLoopButtonPressed() -> void:
	Looper.stopLoop()
	Looper.clearCommands()
	var player = get_parent().get_parent().get_node("GameObjects/Player")
	player.imBeingToldToStop()
	player.resetPosition()
	Gridleton.reloadGridObjects()
	for child in loopItemContainer.get_children():
		child.queue_free()
	Looper.startable = true

func onStopButtonPressed() -> void:
	Looper.stopLoop()
	var player = get_parent().get_parent().get_node("GameObjects/Player")
	player.imBeingToldToStop()
	player.resetPosition()
	Gridleton.reloadGridObjects()
	Looper.startable = true
