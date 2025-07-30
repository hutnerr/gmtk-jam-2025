extends Node

signal escPressed

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS # so we can always listen

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):  # "ui_cancel" is Escape by default
		escPressed.emit()
