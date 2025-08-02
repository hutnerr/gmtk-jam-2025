extends Node

signal commandAdded(command: BaseCommand, index: int)
signal commandRemoved(command: BaseCommand, index: int)

var looping: bool
var commands: Array[BaseCommand]
var loopLimit: int
var startable: bool = true
var currentLoopId: int = 0

func addCommand(command: BaseCommand, index: int) -> bool:
	# FIXME: error handling
	commands.insert(index, command)
	commandAdded.emit(command, index)
	return true

func getCommandIndex(cmd: BaseCommand) -> int:
	for i in range(len(commands)):
		var tempCmd = commands[i]
		if tempCmd == cmd:
			return i
	return -1

func removeCommand(index: int) -> bool:
	# FIXME: error handling
	var cmd = commands[index]
	commands.remove_at(index)
	commandRemoved.emit(cmd, index)
	return true

func appendCommand(command: BaseCommand) -> bool:
	if len(commands) >= loopLimit:
		return false
	
	commands.append(command)
	commandAdded.emit(command, len(commands) - 1)
	return true

func runLoop() -> void:
	if len(commands) <= 0:
		return
	
	if looping == true:
		return
	
	looping = true
	currentLoopId += 1
	var thisLoopId = currentLoopId
	
	var timesNotMoving: int = 0
	var lastPos: Vector2i = Vector2i.ZERO
	
	while looping and currentLoopId == thisLoopId:
		for i in len(commands):
			if not looping or currentLoopId != thisLoopId:
				return
				
			var command = commands[i]
			if command == null:
				continue
				
			var player = get_tree().current_scene.get_node("GameObjects").get_node("Player")
			if not player:
				looping = false
				return
			
			if player.gridPos == lastPos:
				timesNotMoving += 1
			
			if timesNotMoving >= 50:
				Looper.stopLoop()
				player.imBeingToldToStop()
				player.resetPosition()
				Gridleton.reloadGridObjects()
				print("PREVENTED INFINITE LOOP AND RESET")
				
			lastPos = player.gridPos
			
			# get the players current position, check it to the last position
			# if its the same, add one to times not looping, if that ever reaches 10 thenn
			# we stop looping to prevent infinite loops
				
			await player.takeTurn(command, thisLoopId)
			
			if not looping or currentLoopId != thisLoopId:
				return

func stopLoop() -> void:
	looping = false
	currentLoopId += 1

func clearCommands() -> void:
	commands = []

func loadNewLevel(loopLimit: int) -> void:
	self.loopLimit = loopLimit
	clearCommands()
