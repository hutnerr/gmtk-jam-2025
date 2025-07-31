class_name BaseCommand extends Node

enum Commands {
	RIGHT, 
	LEFT, 
	UP, 
	DOWN,
	ROTATE90,
	ROTATE180,
	ROTATE270
}

var cmdName: String
var direction: Vector2i
var rotationDegrees: int

func _init(cmdName: String, dir: Vector2i = Vector2i.ZERO, rot: int = 0) -> void:
	self.cmdName = cmdName
	self.direction = dir
	self.rotationDegrees = rot

func applyCommand() -> void:
	MoveManny.move(self)

static func createCommand(cmd: BaseCommand.Commands) -> BaseCommand:
	match cmd:
		BaseCommand.Commands.RIGHT:
			return BaseCommand.new("Right", Vector2i(1, 0))
		BaseCommand.Commands.LEFT:
			return BaseCommand.new("Left", Vector2i(-1, 0))
		BaseCommand.Commands.UP:
			return BaseCommand.new("Up", Vector2i(0, 1))
		BaseCommand.Commands.DOWN:
			return BaseCommand.new("Down", Vector2i(0, -1))
		BaseCommand.Commands.ROTATE90:
			return BaseCommand.new("Rotate90", Vector2i.ZERO, 90)
		BaseCommand.Commands.ROTATE180:
			return BaseCommand.new("Rotate180", Vector2i.ZERO, 180)
		BaseCommand.Commands.ROTATE270:
			return BaseCommand.new("Rotate270", Vector2i.ZERO, 270)
		_:
			return BaseCommand.new("NONE", Vector2i.ZERO)
