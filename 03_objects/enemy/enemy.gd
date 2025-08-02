extends GridObject



@onready var hitbox: Area2D = $Area2D

func _ready() -> void:
	type = GridObject.ObjectType.ENEMY
	hitbox.area_entered.connect(onAreaEntered)
	
	




# Should play some sort of death animation, then connect that to this invisibility thing
func onAreaEntered(area):
	if self.is_visible_in_tree():
		self.visible = false
