extends CanvasLayer

const Heart_Row_size = 4
const Heart_offset = 150
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var heart_container = $heart

func update_hearts():
	var hearts = max(int(PlayerData.heart), 0)
	for i in range(heart_container.get_child_count()):
		var heart = heart_container.get_child(i)
		heart.frame = 0 if i < hearts else 3
func _process(delta):
	display_heart()
	update_hearts()
# Called when the node enters the scene tree for the first time.

func _ready():
	add_to_group("GUI")
	for i in range(PlayerData.max_heart):
		var new_heart = Sprite.new()
		new_heart.texture = $heart.texture
		new_heart.hframes = $heart.hframes
		heart_container.add_child(new_heart)
	add_to_group("GUI")

func display_heart():
	for heart in heart_container.get_children():
		var index = heart.get_index()
		var x = (index % Heart_Row_size) * Heart_offset
		var y = int(index / Heart_Row_size) * Heart_offset
		heart.position = Vector2(x, y)
