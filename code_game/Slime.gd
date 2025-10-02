extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export onready var animationPlayer = get_node("slimeanim")

# Called when the node enters the scene tree for the first time.
func _ready():
	$slimeanim.play("Idle")
	animationPlayer.playback_speed = 0.75
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
