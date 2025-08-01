extends CanvasLayer

var nextLevelPath = {
	"LevelOne" : ["res://05_levels/2/Level2.tscn", "Two"], # the path, the level to load for Looper
	"LevelTwo" : null,
	"LevelEight" : null # cutscene goes here 
}

signal sceneChanged
const mainPath = "res://00_main/Main.tscn"

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	Gridleton.allEnemiesKilled.connect(nextLevel)

func change_scene(target: String) -> void:
	$AnimationPlayer.play("dissolve")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(target)
	$AnimationPlayer.play_backwards("dissolve")
	sceneChanged.emit()

func nextLevel() -> void:
	var currentLevel = get_tree().current_scene.name
	#await MoveManny.player.animPlayer.animation_finished
	#await get_tree().create_timer(0.5).timeout
	change_scene(nextLevelPath[currentLevel][0])
	Looper.loadNewLevel(nextLevelPath[currentLevel][1])
