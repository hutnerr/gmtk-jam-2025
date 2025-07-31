extends Node2D

var levelLimit
var commands: Array[BaseCommand]
var looping: bool

func _ready() -> void:
	loadNewLevel(0)

func addCommand(command: BaseCommand, location: int) -> void:	
	commands.insert(location, command)

func appendCommand(command: BaseCommand) -> void:
	commands.append(command)
	print("Command Appended: ", commands)
	
func removeCommand(location: int) -> void:
	commands.remove_at(location)
	
func runLoop() -> void:
	MoveManny.reset()
	looping = true
	
	while looping:
		if commands.is_empty():
			await get_tree().create_timer(0.1).timeout
			looping = false
			return
		
		for command in commands:
			if command == null:
				continue
			
			if not looping:
				break
			
			# TODO: make an animation and await that being done here instead
			await get_tree().create_timer(1.0).timeout
			
			if not looping: # if we've stopped looping during our wait
				break
			
			command.applyCommand()

func clearCommands() -> void:
	commands = []

func loadNewLevel(levelLimit) -> void:
	self.levelLimit = levelLimit
	clearCommands()
	self.commands.resize(levelLimit)
