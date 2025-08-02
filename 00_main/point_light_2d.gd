extends PointLight2D

@export var flickerMin: float = 0.9
@export var flickerMax: float = 1.0
@export var baseFlickerTime: float = 1.0
@export var rangeMin: float = 450
@export var rangeMax: float = 400

var currentEnergy: float = randf_range(flickerMin, flickerMax)
var wantedEnergy: float = randf_range(flickerMin, flickerMax)
var flickerTime: float = 0.0
var flickerIterator: float = 0.0

func _process(delta):
	flickerTime -= delta
	self.energy += flickerIterator * delta
	if flickerTime <= 0:
		flickerTime = baseFlickerTime
		wantedEnergy = randf_range(flickerMin, flickerMax)
		flickerIterator = (wantedEnergy - self.energy) / baseFlickerTime
		currentEnergy = self.energy
