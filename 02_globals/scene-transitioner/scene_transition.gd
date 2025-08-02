extends CanvasLayer

var nextLevelPath = {
	"One" : "res://05_levels/Level2.tscn",
	"Two" : "res://00_main/Main.tscn",
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
	await get_tree().create_timer(0.5).timeout
	var level = get_tree().current_scene.get_node("BaseLevel")
	change_scene(nextLevelPath[level.levelString])
	Looper.loadNewLevel(level.loopLimit)
	
