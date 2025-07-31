extends Control

@onready var playButton: Button = $MainContainer/RunButton/Button/HBoxContainer/PlayButton
@onready var rightButton: Button = $MainContainer/CommandSequencePanel/CommandsContainer/HBoxContainer/CMDButtonMargin/CMDButtonVBox/RightButton
@onready var leftButton: Button = $MainContainer/CommandSequencePanel/CommandsContainer/HBoxContainer/CMDButtonMargin/CMDButtonVBox/LeftButton
@onready var upButton: Button = $MainContainer/CommandSequencePanel/CommandsContainer/HBoxContainer/CMDButtonMargin/CMDButtonVBox/UpButton
@onready var downButton: Button = $MainContainer/CommandSequencePanel/CommandsContainer/HBoxContainer/CMDButtonMargin/CMDButtonVBox/DownButton
@onready var rotate90Button: Button = $MainContainer/CommandSequencePanel/CommandsContainer/HBoxContainer/CMDButtonMargin/CMDButtonVBox/Rotate90Button
@onready var rotate180Button: Button = $MainContainer/CommandSequencePanel/CommandsContainer/HBoxContainer/CMDButtonMargin/CMDButtonVBox/Rotate180Button
@onready var rotate270Button: Button = $MainContainer/CommandSequencePanel/CommandsContainer/HBoxContainer/CMDButtonMargin/CMDButtonVBox/Rotate270Button

@onready var clearLoopButton: Button = $MainContainer/CommandSequencePanel/CommandsContainer/HBoxContainer/LoopContainer/LoopItemVBox/MarginContainer2/ClearLoopButton
@onready var stopButton: Button = $MainContainer/RunButton/Button/HBoxContainer/StopButton

@onready var loopItemContainer: VBoxContainer = $MainContainer/CommandSequencePanel/CommandsContainer/HBoxContainer/LoopContainer/LoopItemVBox/MarginContainer/LoopItemMainContainer

# Called when the node enters the scene tree for the first time.
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
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
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
		renderCommand(cmd, i)

func renderCommand(cmd: BaseCommand, index: int) -> void:
	var label = Label.new()
	label.text = str(index + 1, ": ", cmd.cmdName)
	loopItemContainer.add_child(label)
	# these should be in a HBoxContainer, which is added
	# the items inside should be the label, an up btn, down btn, and a X btn.
	# if up/down it should swap its position with the one above/below it in Looper.commands
	# it should check ranges while doing this. the X button should remove it from the commands
	
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
	Looper.clearCommands()
	MoveManny.reset()
	emptyLoopItemContainer()

func onStopButtonPressed() -> void:
	Looper.looping = false
	MoveManny.reset()
