extends CanvasLayer

var nextLevelPath = {
	"One" : "res://05_levels/Level2.tscn",
	"Two" : "res://05_levels/Level3.tscn",
	"Three" : "res://05_levels/Level4.tscn",
	"Four" : "res://05_levels/Level5.tscn",
	"Five" : "res://05_levels/Level6.tscn",
	"Six" : "res://05_levels/Level7.tscn",
	"Seven" : "res://05_levels/Level8.tscn", 
	#"Eight" : "res://05_levels/FinalCutscene.tscn",
	"Eight" : "res://05_levels/Level9.tscn",
	"Nine" : "res://05_levels/Level10.tscn",
	"Ten" : "res://05_levels/Level11.tscn",
	"Eleven" : "res://05_levels/Level12.tscn",
	"Twelve" : "res://05_levels/Level13.tscn",
	"Thirteen" : "res://05_levels/Level14.tscn",
	"Fourteen" : "res://05_levels/Level15.tscn",
	"Fifteen" : "res://05_levels/Level16.tscn",
	"Sixteen" : "res://05_levels/LevelTP.tscn",
	"???" : "res://01_user-interface/FinalCutscene.tscn"
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
	await get_tree().create_timer(0.5).timeout # play after 2 secs
	var level = get_tree().current_scene.get_node("BaseLevel")
	change_scene(nextLevelPath[level.levelString])
	Looper.loadNewLevel(level.loopLimit)
	
