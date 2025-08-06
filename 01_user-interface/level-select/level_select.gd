extends Control

const LEVELS_PATH = "res://05_levels/LevelFORMAT.tscn"

@onready var l1btn: Button = $"Panel/MarginContainer/VBoxContainer/HBoxContainer/OddButtons/1Button"
@onready var l2btn: Button = $"Panel/MarginContainer/VBoxContainer/HBoxContainer/EvenButtons/2Button"
@onready var l3btn: Button = $"Panel/MarginContainer/VBoxContainer/HBoxContainer/OddButtons2/3Button"
@onready var l4btn: Button = $"Panel/MarginContainer/VBoxContainer/HBoxContainer/EvenButtons2/4Button"
@onready var l5btn: Button = $"Panel/MarginContainer/VBoxContainer/HBoxContainer/OddButtons/5Button"
@onready var l6btn: Button = $"Panel/MarginContainer/VBoxContainer/HBoxContainer/EvenButtons/6Button"
@onready var l7btn: Button = $"Panel/MarginContainer/VBoxContainer/HBoxContainer/OddButtons2/7Button"
@onready var l8btn: Button = $"Panel/MarginContainer/VBoxContainer/HBoxContainer/EvenButtons2/8Button"
@onready var l9btn: Button = $"Panel/MarginContainer/VBoxContainer/HBoxContainer/OddButtons/9Button"
@onready var l10btn: Button = $"Panel/MarginContainer/VBoxContainer/HBoxContainer/EvenButtons/10Button"
@onready var l11btn: Button = $"Panel/MarginContainer/VBoxContainer/HBoxContainer/OddButtons2/11Button"
@onready var l12btn: Button = $"Panel/MarginContainer/VBoxContainer/HBoxContainer/EvenButtons2/12Button"
@onready var l13btn: Button = $"Panel/MarginContainer/VBoxContainer/HBoxContainer/OddButtons/13Button"
@onready var l14btn: Button = $"Panel/MarginContainer/VBoxContainer/HBoxContainer/EvenButtons/14Button"
@onready var l15btn: Button = $"Panel/MarginContainer/VBoxContainer/HBoxContainer/OddButtons2/15Button"
@onready var l16btn: Button = $"Panel/MarginContainer/VBoxContainer/HBoxContainer/EvenButtons2/16Button"

@onready var closeBtn: Button = $Panel/MarginContainer/VBoxContainer/MarginContainer/CloseButton

func _ready() -> void:
	var btns: Array[Button] = [l1btn, l2btn, l3btn, l4btn, l5btn, l6btn, l7btn, l8btn, l9btn, l10btn, l11btn, l12btn, l13btn, l14btn, l15btn, l16btn]
	for btn in btns:
		btn.pressed.connect(onLevelButtonPressed.bind(btn))
	closeBtn.pressed.connect(onCloseButtonPressed)

	# nightmare code
	for level_num in SceneTransitioner.levelsComplete:
		if SceneTransitioner.levelsComplete[level_num]:
			match level_num:
				1:
					l1btn.disabled = false
				2:
					l2btn.disabled = false
				3:
					l3btn.disabled = false
				4:
					l4btn.disabled = false
				5:
					l5btn.disabled = false
				6:
					l6btn.disabled = false
				7:
					l7btn.disabled = false
				8:
					l8btn.disabled = false
				9:
					l9btn.disabled = false
				10:
					l10btn.disabled = false
				11:
					l11btn.disabled = false
				12:
					l12btn.disabled = false
				13:
					l13btn.disabled = false
				14:
					l14btn.disabled = false
				15:
					l15btn.disabled = false
				16:
					l16btn.disabled = false

func onLevelButtonPressed(button: Button) -> void:
	var btnNum = button.text.strip_edges()
	var path = LEVELS_PATH.replace("FORMAT", btnNum)
	SceneTransitioner.change_scene(path)
	AudiManny.playLevelMusic()
	
func onCloseButtonPressed() -> void:
	visible = false
