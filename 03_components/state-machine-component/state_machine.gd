extends Node
class_name StateMachine

@export var initialState: State

var currentState: State
var states: Dictionary = {}

# This is like the _ready() function, except I want to pass the "parent" as a reference. 
func customInit(parent:Node2D)-> void:
	for child in get_children():
		if child is State:
			child.parent = parent
			states[child.name.to_lower()] = child
			child.transitioned.connect(onChildTransition)

	if initialState:
		initialState.enter()
		currentState = initialState

func _process(delta: float) -> void:
	if currentState:
		currentState.update(delta)
		
func changeState(state, newStateName):
	if state != currentState:
		return
	
	var newState = states.get(newStateName.to_lower())
	if !newState:
		return

	if currentState:
		currentState.exit()

	newState.enter()

	print("Changing State: ", currentState, " -> ", newState)
	
	currentState = newState


func onChildTransition(state, newStateName):
	changeState(state, newStateName)
