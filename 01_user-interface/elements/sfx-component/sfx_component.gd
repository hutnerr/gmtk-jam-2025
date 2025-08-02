class_name SFXComponent extends Node

const HOVER_AUDIO: String = "res://99_assets/music/bookOpen.ogg"
const PRESSED_AUDIO: String = "res://99_assets/music/bookFlip2.ogg"
const DISABLED_AUDIO: String = "res://99_assets/music/02_chest_close_2.wav"

@export var hoverStream: AudioStream = preload(HOVER_AUDIO)
@export var pressedStream: AudioStream = preload(PRESSED_AUDIO)
@export var disabledStream: AudioStream = preload(DISABLED_AUDIO)

var audioPlayer: AudioStreamPlayer
var target: Control

func _ready() -> void:
	audioPlayer = AudioStreamPlayer.new()
	audioPlayer.name = "AudioStreamPlayer"
	audioPlayer.bus = "sfx"
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
	if audioPlayer:
		if target is Button and target.disabled and disabledStream:
			return
		elif hoverStream:
			audioPlayer.stream = hoverStream
			audioPlayer.play()

func onPressed() -> void:
	if audioPlayer and pressedStream:
		audioPlayer.stream = pressedStream
		audioPlayer.play()

func onGuiInput(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		if mouse_event.pressed and mouse_event.button_index == MOUSE_BUTTON_LEFT:
			onPressed()
