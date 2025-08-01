extends Node

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

func removeCommand(location: int) -> void:
	commands.remove_at(location)

func appendCommand(command: BaseCommand) -> void:
	if len(commands) >= levelLimit:
		print("go over our limit")
		return
	commands.append(command)

func runLoop() -> void:
	MoveManny.reset()
	looping = true
	while looping:
		for i in len(commands):
			var command = commands[i]
			if command == null:
				continue
			
			if not looping:
				break
			
			# TODO: make an animation and await that being done here instead
			# FIXME: store the objects we need to tell to take its turn the call that here instead
			# and wait for them to tell us its done
			# need a way to tell that we've taken our turn
			# call each grid object, tell them to take their turn, and pass them the current command
			# might have to check if Looper.looping when taking our turn
			await get_tree().create_timer(2).timeout
			
			if not looping: # if we've stopped looping during our wait
				break
			
			command.applyCommand()
			currentCommand = i

func clearCommands() -> void:
	commands = []

# FIXME: maybe change?
func loadNewLevel(level: String) -> void:
	self.currentLevel = level
	self.levelLimit = levelLimits[level]
	clearCommands()
