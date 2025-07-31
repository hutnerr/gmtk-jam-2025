extends Control

const LEVELS_PATH = "res://05_levels/FORMAT/LevelFORMAT.tscn"

@onready var l1btn: Button = $"Panel/MarginContainer/VBoxContainer/HBoxContainer/OddButtons/1Button"
@onready var l2btn: Button = $"Panel/MarginContainer/VBoxContainer/HBoxContainer/EvenButtons/2Button"
@onready var l3btn: Button = $"Panel/MarginContainer/VBoxContainer/HBoxContainer/OddButtons/3Button"
@onready var l4btn: Button = $"Panel/MarginContainer/VBoxContainer/HBoxContainer/EvenButtons/4Button"
@onready var l5btn: Button = $"Panel/MarginContainer/VBoxContainer/HBoxContainer/OddButtons/5Button"
@onready var l6btn: Button = $"Panel/MarginContainer/VBoxContainer/HBoxContainer/EvenButtons/6Button"
@onready var l7btn: Button = $"Panel/MarginContainer/VBoxContainer/HBoxContainer/OddButtons/7Button"
@onready var l8btn: Button = $"Panel/MarginContainer/VBoxContainer/HBoxContainer/EvenButtons/8Button"
@onready var closeBtn: Button = $Panel/MarginContainer/VBoxContainer/MarginContainer/CloseButton

func _ready() -> void:
	var btns: Array[Button] = [l1btn, l2btn, l3btn, l4btn, l5btn, l6btn, l7btn, l8btn]
	for btn in btns:
		btn.pressed.connect(onLevelButtonPressed.bind(btn))
	closeBtn.pressed.connect(onCloseButtonPressed)

func onLevelButtonPressed(button: Button) -> void:
	var btnNum = button.text  # Assuming button text is "1", "2", etc.
	var path = LEVELS_PATH.replace("FORMAT", btnNum)
	SceneTransitioner.change_scene(path)
	
func onCloseButtonPressed() -> void:
	visible = false
