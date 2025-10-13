extends Area2D

export var speed = 200
var direction = Vector2.ZERO

onready var sprite = $AnimatedSprite  # สมมติ node ชื่อ Sprite
var can_damage = true
func _ready():

	# ✅ หัน sprite ตามทิศทางการยิง
	sprite.flip_h = direction.x > 0

	# ทำลายตัวเองหลัง 2 วิ กันค้าง
	var timer = Timer.new()
	timer.wait_time = 2.0
	timer.one_shot = true
	timer.autostart = true
	add_child(timer)
	timer.connect("timeout", self, "_on_Timer_timeout")


func _process(delta):
	position += direction * speed * delta

func take_damage(player):
	PlayerData.heart -= 1
	PlayerData.heart = max(PlayerData.heart, 0)

	# อัปเดต GUI
	for gui in get_tree().get_nodes_in_group("GUI"):
		gui.update_hearts()

	if PlayerData.heart <= 0:
		player.die()



func _on_Area2D_body_entered(body):
	if body.name == "Player" and can_damage:
		take_damage(body)


func _on_Timer_timeout():
	if is_instance_valid(self):
		queue_free()  # ลบ projectile หลัง 2 วิ
