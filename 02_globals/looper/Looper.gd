extends Node

signal commandAdded(command: BaseCommand, index: int)
signal commandRemoved(command: BaseCommand, index: int)

var looping: bool
var commands: Array[BaseCommand]
var loopLimit: int

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
	while looping:
		for i in len(commands):
			var command = commands[i]
			if command == null:
				continue
				
			for gridObject: GridObject in Gridleton.gridObjects:
				if not looping:
					break

				gridObject.takeTurn(command)
				
				if not looping:
					break
					
				# each gridObject emits a signal
				# await the taking of turn, likely animation being played there

			# call each grid object, tell them to take their turn, and pass them the current command
			# might have to check if Looper.looping when taking our turn
			await get_tree().create_timer(2).timeout
			
			if not looping: # if we've stopped looping during our wait
				break

func clearCommands() -> void:
	commands = []

func loadNewLevel(loopLimit: int) -> void:
	self.loopLimit = loopLimit
	clearCommands()
