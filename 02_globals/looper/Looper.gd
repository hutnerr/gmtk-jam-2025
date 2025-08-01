extends Node2D

var levelLimits: Dictionary[String, int] = {
	"INIT" : 0,
	"One" : 2,
	"Two" : 5
}

var levelLimit: int
var commands: Array[BaseCommand]
var looping: bool
var currentCommand # index of current cmd, or null
var currentLevel: String # One, Two, etc

func _ready() -> void:
	loadNewLevel("INIT") # initializes

func addCommand(command: BaseCommand, location: int) -> void:	
	commands.insert(location, command)

func appendCommand(command: BaseCommand) -> void:
	if len(commands) >= levelLimit:
		print("go over our limit")
		return
		
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
		
		for i in len(commands):
			var command = commands[i]
			if command == null:
				continue
			
			if not looping:
				break
			
			# TODO: make an animation and await that being done here instead
			await get_tree().create_timer(1).timeout
			
			if not looping: # if we've stopped looping during our wait
				break
			
			command.applyCommand()
			currentCommand = i

func clearCommands() -> void:
	commands = []

func loadNewLevel(level: String) -> void:
	self.currentLevel = level
	self.levelLimit = levelLimits[level]
	clearCommands()
	#self.commands.resize(levelLimit)
