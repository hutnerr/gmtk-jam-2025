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
		print("go over our limit")
		return false
	commands.append(command)
	commandAdded.emit(command, len(commands) - 1)
	return true

func runLoop() -> void:
	if len(commands) <= 0:
		print("invalid loop to run")
		return
	
	if looping == true:
		print("already looping")
		return
	
	looping = true
	currentLoopId += 1
	var thisLoopId = currentLoopId
	
	print("Starting loop with ID: ", thisLoopId)
	
	while looping and currentLoopId == thisLoopId:
		print("we are looping with ID: ", thisLoopId)
		for i in len(commands):
			# Check if we should still be running THIS specific loop
			if not looping or currentLoopId != thisLoopId:
				print("Loop ", thisLoopId, " was cancelled")
				return
				
			var command = commands[i]
			if command == null:
				continue
				
			var player = get_tree().current_scene.get_node("GameObjects").get_node("Player")
			if not player:
				looping = false
				return
				
			print("Executing command in loop ", thisLoopId)
			# AWAIT the takeTurn function directly
			await player.takeTurn(command, thisLoopId)
			
			# Check again after the turn is completely done
			if not looping or currentLoopId != thisLoopId:
				print("Loop ", thisLoopId, " was cancelled after turn")
				return

func stopLoop() -> void:
	print("Stopping loop. Current ID: ", currentLoopId)
	looping = false
	currentLoopId += 1  # This invalidates any running loops

func clearCommands() -> void:
	commands = []

func loadNewLevel(loopLimit: int) -> void:
	self.loopLimit = loopLimit
	clearCommands()
