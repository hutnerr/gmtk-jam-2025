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

@onready var allCmdButtons = [
	upButton,
	leftButton,
	rightButton,
	downButton,
	rotate90Button,
	rotate180Button,
	rotate270Button,
]

#@onready var playerRef = get_parent().get_parent().get_node("GameObjects").get_node("Player")
@onready var playerRef = get_parent().get_parent().get_parent().get_node("GameObjects").get_node("Player")

func _ready() -> void:
	playButton.pressed.connect(onPlayButtonPressed)
	stopButton.pressed.connect(onStopButtonPressed)
	clearLoopButton.pressed.connect(onClearLoopButtonPressed)

	for button in commandButtonMap.keys():
		button.pressed.connect(onCommandButtonPressed.bind(commandButtonMap[button]))

	var level = get_tree().current_scene.get_node("BaseLevel")
	levelInfoLabel.text += level.levelString
	loopLimitLabel.text += str(level.loopLimit)
	Looper.loadNewLevel(level.loopLimit, level.levelNum)
	playerRef.rotatedDirection.connect(onRotationApplied)

func onRotationApplied(rotationDeg: int) -> void:
	# change the text of the labels in the loopItemContainer
	for labelItem in loopItemContainer.get_children():
		labelItem.text = changeTextForRotation(labelItem.text, rotationDeg)
	AudiManny.playRotationSFX()

func changeTextForRotation(originalText: String, rotationDeg: int) -> String:
	# Extract the number and current direction from the label text
	var parts = originalText.split(": ")
	if parts.size() != 2:
		return originalText  # Return unchanged if format is unexpected
	
	var number = parts[0]
	var currentDirection = parts[1]
	var newDirection = ""
	
	# Apply rotation transformation based on current direction and rotation amount
	match rotationDeg:
		90:
			match currentDirection:
				"Right":
					newDirection = "Up"
				"Up":
					newDirection = "Left"
				"Left":
					newDirection = "Down"
				"Down":
					newDirection = "Right"
				"Rotation90":
					newDirection = "Rotation180"
				"Rotation180":
					newDirection = "Rotation270"
				"Rotation270":
					newDirection = "Rotation0"
				"Rotation0":
					newDirection = "Rotation90"
				_:
					newDirection = currentDirection  # Keep unchanged for unknown directions
		
		180:
			match currentDirection:
				"Right":
					newDirection = "Left"
				"Left":
					newDirection = "Right"
				"Up":
					newDirection = "Down"
				"Down":
					newDirection = "Up"
				"Rotation90":
					newDirection = "Rotation270"
				"Rotation180":
					newDirection = "Rotation0"
				"Rotation270":
					newDirection = "Rotation90"
				"Rotation0":
					newDirection = "Rotation180"
				_:
					newDirection = currentDirection
		
		270:
			match currentDirection:
				"Right":
					newDirection = "Down"
				"Down":
					newDirection = "Left"
				"Left":
					newDirection = "Up"
				"Up":
					newDirection = "Right"
				"Rotation90":
					newDirection = "Rotation0"
				"Rotation180":
					newDirection = "Rotation90"
				"Rotation270":
					newDirection = "Rotation180"
				"Rotation0":
					newDirection = "Rotation270"
				_:
					newDirection = currentDirection
		
		_:
			newDirection = currentDirection  # No change for invalid rotation values
	
	return number + ": " + newDirection

func onCommandButtonPressed(command: BaseCommand.Commands) -> void:
	var cmd: BaseCommand = BaseCommand.createCommand(command)
	var added = Looper.appendCommand(cmd)
	playButton.disabled = false
	clearLoopButton.disabled = false
	if added:
		renderCommand(cmd)

	checkForCMDButtonsDisabled()
	#if len(Looper.commands) - 1 >= Looper.loopLimit:
		#disableCmdButtons()

func _process(delta: float) -> void:
	var children = loopItemContainer.get_children()
	for child in children:
		child.remove_theme_color_override("font_color")
	if Looper.currentIndex >= 0 and Looper.currentIndex < children.size():
		children[Looper.currentIndex].add_theme_color_override("font_color", Color("898d8a"))

func renderCommand(cmd: BaseCommand) -> void:
	var label = Label.new()
	label.add_theme_font_size_override("font_size", 48)
	var index = Looper.getCommandIndex(cmd)
	label.text = str(index + 1, ": ", cmd.cmdName)
	loopItemContainer.add_child(label)

func highlightActiveCommand() -> void:
	# get the active command and make it grey
	# label.add_theme_color_override("font_color", Color("898d8a"))
	# have to store the last one and make it not grey at the same time
	pass

func disableCmdButtons() -> void:
	#print(allCmdButtons)
	for but in allCmdButtons:
		but.disabled = true

func onPlayButtonPressed() -> void:
	if Looper.startable:
		Looper.runLoop()
	else:
		print("not right now lil bro")
	playButton.disabled = true
	stopButton.disabled = false
	clearLoopButton.disabled = false
	disableCmdButtons()

func onClearLoopButtonPressed() -> void:
	Looper.stopLoop()
	Looper.clearCommands()
	#var player = get_parent().get_parent().get_node("GameObjects/Player")
	var player = get_parent().get_parent().get_parent().get_node("GameObjects/Player")
	player.resetPosition()
	player.imBeingToldToStop()
	Gridleton.reloadGridObjects()
	for child in loopItemContainer.get_children():
		child.queue_free()
	Looper.startable = true
	playButton.disabled = true
	clearLoopButton.disabled = true
	stopButton.disabled = true
	
	# turn them all back on
	for but in allCmdButtons:
		but.disabled = false

func onStopButtonPressed() -> void:
	Looper.stopLoop()
	#var player = get_parent().get_parent().get_node("GameObjects/Player")
	var player = get_parent().get_parent().get_parent().get_node("GameObjects/Player")
	player.imBeingToldToStop()
	player.resetPosition()
	Gridleton.reloadGridObjects()
	Looper.startable = true
	playButton.disabled = false
	stopButton.disabled = true
	checkForCMDButtonsDisabled()
	# search through the Looper.commands and render them all
	for child in loopItemContainer.get_children():
		child.queue_free()
	for command in Looper.commands:
		renderCommand(command)

func checkForCMDButtonsDisabled() -> void:
	if len(Looper.commands) == Looper.loopLimit:
		disableCmdButtons()
		return
	for but in allCmdButtons:
		but.disabled = false

	# if length - 1 is loop limimt, we cant add any more
	# then we need to disable them, otherwise we can enable them again
