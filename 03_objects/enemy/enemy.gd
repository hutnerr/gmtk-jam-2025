extends GridObject


@onready var hitbox: Area2D = $Area2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var monkeyAnimRandomization: Array[String] = ["Idle", "Idle", "Idle", "Idle", "Idle", "Stomp", "Stab"]

func _ready() -> void:
	type = GridObject.ObjectType.ENEMY
	hitbox.area_entered.connect(onAreaEntered)
	sprite.animation_finished.connect(onAnimFinished)
	
	
# Should play some sort of death animation, then connect that to this invisibility thing
func onAreaEntered(area):
	if self.is_visible_in_tree():
		sprite.stop()
		sprite.play("Death")
		AudiManny.playEnemyDeadSFX()
		await sprite.animation_finished
		killMyBoi()

func killMyBoi() -> void:
	self.visible = false
	
func onAnimFinished() -> void:
	sprite.play(monkeyAnimRandomization.pick_random())
	
