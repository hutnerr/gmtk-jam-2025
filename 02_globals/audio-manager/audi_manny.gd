extends Node2D

const MENU_MUSIC: String = "res://99_assets/music/main-temp.wav"
const LEVEL_MUSIC: String = "res://99_assets/music/THE_FIELNDS.mp3"
const HOVER_SFX: String = "res://99_assets/music/bookOpen.ogg"
const PRESS_SFX: String = "res://99_assets/music/bookFlip2.ogg"

@onready var menuMusic: AudioStream = preload(MENU_MUSIC)
@onready var levelMusic: AudioStream = preload(LEVEL_MUSIC)
@onready var hoverSFX: AudioStream = preload(HOVER_SFX)
@onready var pressSFX: AudioStream = preload(PRESS_SFX)

@onready var player: AudioStreamPlayer = $AudioStreamPlayer
@onready var SFXPlayer: AudioStreamPlayer = $SFXPlayer

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

func playPressSFX() -> void:
	SFXPlayer.stream = pressSFX
	SFXPlayer.play()

func playHoverSFX() -> void:
	if not SFXPlayer:
		return
	SFXPlayer.stream = hoverSFX
	SFXPlayer.play()

func onFinished() -> void:
	player.play()
