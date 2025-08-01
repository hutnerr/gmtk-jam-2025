class_name SFXComponent extends Node

const HOVER_AUDIO: String = "res://99_assets/music/bookOpen.ogg"
const PRESSED_AUDIO: String = "res://99_assets/music/bookFlip2.ogg"

@export var hoverStream: AudioStream = preload(HOVER_AUDIO)
@export var pressedStream: AudioStream = preload(PRESSED_AUDIO)

var audioPlayer: AudioStreamPlayer2D
var target: Control

func _ready() -> void:
	audioPlayer = AudioStreamPlayer2D.new()
	audioPlayer.name = "AudioStreamPlayer2D"
	add_child(audioPlayer)
	
	if not hoverStream and not pressedStream:
		return
	
	target = get_parent() as Control
	target.mouse_entered.connect(onHover)
	
	# pressed for buttons, onGuiInput for other
	if target.has_signal("pressed"):
		target.pressed.connect(onPressed)
	else:
		target.gui_input.connect(onGuiInput)
	
func onHover() -> void:
	if audioPlayer and hoverStream:
		audioPlayer.stream = hoverStream
		audioPlayer.play()

func onPressed() -> void:
	if audioPlayer and pressedStream:
		audioPlayer.stream = pressedStream
		audioPlayer.play()

# done this way so it can be on more than just buttons
func onGuiInput(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		if mouse_event.pressed and mouse_event.button_index == MOUSE_BUTTON_LEFT:
			onPressed()
