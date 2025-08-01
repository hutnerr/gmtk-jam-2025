extends Node2D

const MENU_MUSIC: String = "res://99_assets/music/main-temp.wav"
const LEVEL_MUSIC: String = "res://99_assets/music/THE_FIELNDS.mp3"

@onready var menuMusic: AudioStream = preload(MENU_MUSIC)
@onready var levelMusic: AudioStream = preload(LEVEL_MUSIC)
@onready var player: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	player.stream = menuMusic
	player.play()
	player.finished.connect(onFinished)

func playMenuMusic() -> void:
	player.stream_paused = true
	player.stream = menuMusic
	player.play()
	
func playLevelMusic() -> void:
	player.stream_paused = true
	player.stream = levelMusic
	player.play()

func onFinished() -> void:
	player.play()
