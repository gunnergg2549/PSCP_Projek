extends Area2D
export onready var sprite = $AnimatedSprite
onready var gui = get_parent().get_node("GUI")
var used:bool = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func _ready():
	sprite.play("blink")

# Called when the node enters the scene tree for the first time.
func _on_pop_body_entered(body):
	if body.name == "Player" and !used:
		give_hurt(body)
		used = true

func give_hurt(player):
	player.damage()
	for gui in get_tree().get_nodes_in_group("GUI"):
		gui.update_hearts()
	if PlayerData.heart <= 0:
		player.die()
	queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
