extends CanvasLayer

var nextLevelPath = {
	"One" : "res://05_levels/Level2.tscn",
	"Two" : "res://05_levels/Level3.tscn",
	"Three" : "res://05_levels/Level4.tscn",
	"Four" : "res://05_levels/Level5.tscn",
	"Five" : "res://05_levels/Level6.tscn",
	"Six" : "res://05_levels/Level7.tscn",
	"Seven" : "res://05_levels/Level8.tscn", 
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

var levelsComplete = {
	1 : true,
	2 : false,
	3 : false,
	4 : false,
	5 : false,
	6 : false,
	7 : false,
	8 : false, 
	9 : false,
	10 : false, 
	11 : false,
	12 : false,
	13 : false,
	14 : false, 
	15 : false, 
	16 : false,
	17 : false # to prevent invalid accesses lol
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
	print("Completed level: ", level.levelNum, " opening access to : ", level.levelNum + 1)
	levelsComplete[level.levelNum + 1] = true # open up the next level
	change_scene(nextLevelPath[level.levelString])
	Looper.loadNewLevel(level.loopLimit, level.levelNum)
	
func completeLevel(level: int) -> void:
	levelsComplete[level] = true
	
