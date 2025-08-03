extends Node

const MENU_MUSIC: String = "res://99_assets/music/main-temp.wav"
#const MENU_MUSIC: String = "res://99_assets/music/guitar-mainloop.wav"
#const MENU_MUSIC: String = "res://99_assets/music/guitar-start.wav"
const LEVEL_MUSIC: String = "res://99_assets/music/final.wav"

const HOVER_SFX: String = "res://99_assets/music/bookOpen.ogg"
const PRESS_SFX: String = "res://99_assets/music/bookFlip2.ogg"
const FAIL_SFX: String = "res://99_assets/music/04_sack_open_1.wav"
const PORTAL_SFX: String = "res://99_assets/music/portal.wav"
const ROTATION_SFX: String = "res://99_assets/music/beltHandle2.ogg"
const WALLHIT_SFX: String = "res://99_assets/music/dropLeather.ogg"
const ENEMYDEAD_SFX: String = "res://99_assets/music/24_orc_death_spin.wav"

@onready var menuMusic: AudioStream = preload(MENU_MUSIC)
@onready var levelMusic: AudioStream = preload(LEVEL_MUSIC)
@onready var hoverSFX: AudioStream = preload(HOVER_SFX)
@onready var pressSFX: AudioStream = preload(PRESS_SFX)
@onready var failSFX: AudioStream = preload(FAIL_SFX)
@onready var portalSFX: AudioStream = preload(PORTAL_SFX)
@onready var rotationSFX: AudioStream = preload(ROTATION_SFX)
@onready var wallHitSFX: AudioStream = preload(WALLHIT_SFX)
@onready var enemyDeadSFX: AudioStream = preload(ENEMYDEAD_SFX)

@onready var musicPlayer: AudioStreamPlayer = $MusicPlayer
@onready var SFXPlayer: AudioStreamPlayer = $SFXPlayer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	musicPlayer.stream = menuMusic
	musicPlayer.play()
	musicPlayer.finished.connect(onFinished)

func playMenuMusic() -> void:
	musicPlayer.stop()
	musicPlayer.stream_paused = true
	musicPlayer.stream = menuMusic
	musicPlayer.play()
	
func playLevelMusic() -> void:
	musicPlayer.stream_paused = true
	musicPlayer.stream = levelMusic
	musicPlayer.play()

func playPressSFX() -> void:
	SFXPlayer.stream = pressSFX
	SFXPlayer.play()

func playFailSFX() -> void:
	SFXPlayer.stream = failSFX
	SFXPlayer.play()

func playHoverSFX() -> void:
	if not SFXPlayer:
		return
	SFXPlayer.stream = hoverSFX
	SFXPlayer.play()

func playPortalSFX() -> void:
	SFXPlayer.stream = portalSFX
	SFXPlayer.play()

func playRotationSFX() -> void:
	SFXPlayer.stream = rotationSFX
	SFXPlayer.play()

func playEnemyDeadSFX() -> void:
	SFXPlayer.stream = enemyDeadSFX
	SFXPlayer.play()

func playWallHitSFX() -> void:
	var originalVolume = SFXPlayer.volume_db
	SFXPlayer.volume_db = originalVolume - 15
	SFXPlayer.stream = wallHitSFX
	SFXPlayer.play()
	await SFXPlayer.finished
	SFXPlayer.volume_db = originalVolume

func onFinished() -> void:
	musicPlayer.play()
	
func stop() -> void:
	SFXPlayer.stop()
	musicPlayer.stop()
