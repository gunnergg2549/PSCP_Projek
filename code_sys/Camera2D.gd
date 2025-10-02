extends Camera2D

onready var player  = $"../Player"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum CameraState { FOLLOW, PANNING }
export(CameraState) var camera = CameraState.FOLLOW

# Called when the node enters the scene tree for the first time.
func _process(delta):
	match camera:
		CameraState.FOLLOW:
			camera_following()
		CameraState.PANNING:
			camera_panning()

#Camera Panning when Player reach camera edge
func camera_panning():
	anchor_mode = Camera2D.ANCHOR_MODE_FIXED_TOP_LEFT
	position = player.position
	var x = floor(position.x / 480)*480
	var y = floor(position.y / 320)*320
	
	position = Vector2(x,y)
	
	var tween := create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self,"position",Vector2(x,y),0.025)
	
#Camera following Player
func camera_following():
	anchor_mode = Camera2D.ANCHOR_MODE_DRAG_CENTER
	position = player.position
