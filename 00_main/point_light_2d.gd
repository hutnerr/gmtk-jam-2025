extends PointLight2D

@export var flickerMin: float = 0.9
@export var flickerMax: float = 1.0
@export var baseFlickerTime: float = 1.0
@export var rangeMin: float = 450
@export var rangeMax: float = 400

var flickerTime = baseFlickerTime
func _process(delta):
	flickerTime -= delta
	if flickerTime <= 0:
		flickerTime = baseFlickerTime
		self.energy = randf_range(flickerMin, flickerMax)
		
		#it would be cool to change the range, but I can't figure that out right now
