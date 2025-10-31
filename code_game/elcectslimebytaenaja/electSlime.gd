extends KinematicBody2D

class_name elec_slime

var is_slime_chase = false
var player = null

var health = 80
var health_max = 80
var health_min = 0

var dead: bool = false
var taking_damage: bool = false
var damage_to_deal = 2
var is_dealing_damage = false

const speed = 50
var velocity = Vector2()
var dir = Vector2.RIGHT # ทิศทางเริ่มต้น
const gravity = 900
var knockback_force = 200
var is_roaming = true
#Array ของเวลาที่ต้องการสุ่มไว้ล่วงหน้า
var wait_times = [1.5, 2.0, 2.5]
# Array ของทิศทาง
var directions = [Vector2.RIGHT, Vector2.LEFT]

func _ready():
	randomize() 
	$DirectionTimer.connect("timeout", self, "_on_DirectionTimer_timeout")
	# 3. เริ่มเดินนับเวลา
	$DirectionTimer.start()
	$detectradius.connect("body_entered", self, "_on_DetectionRadius_body_entered")
	$detectradius.connect("body_exited", self, "_on_DetectionRadius_body_exited")

func _physics_process(_delta):
	if !is_on_floor():
		velocity.y += gravity * _delta
	else:
		move()
		handle_animation()
	velocity = move_and_slide(velocity, Vector2.UP)

func move():
	if dead:
		velocity.x = 0
		return
	
	if !is_slime_chase:
		velocity.x = dir.x * speed
		is_roaming = true
	else:
			if player != null:
				# 1.คำนวณทิศทางไปหาผู้เล่น
				var direction_to_player = (player.global_position - global_position).normalized()
				# 2.ตั้งค่าความเร็ว
				velocity.x = direction_to_player.x * speed
				if direction_to_player.x != 0:
					dir.x = sign(direction_to_player.x)
			else:
				# กันเหนียว ถ้า player เป็น null แต่ is_slime_chase ค้าง
				velocity.x = 0
				is_slime_chase = false # กลับไปเดินสุ่ม
func handle_animation():
	var anim_sprite = $AnimatedSprite
	if !dead and !taking_damage and !is_dealing_damage:
		anim_sprite.play("walk")
		if dir.x == -1:
			anim_sprite.flip_h = false
		elif dir.x == 1:
			anim_sprite.flip_h = true
# ฟังก์ชันนี้จะถูกเรียกใช้ *ก็ต่อเมื่อ* Signal ถูกเชื่อมต่อแล้ว
func _on_DirectionTimer_timeout():
	# print("TIMER TIMEOUT! กำลังจะเปลี่ยนทิศทาง") # <-- เอาไว้ทดสอบ

	# สุ่มเวลา
	$DirectionTimer.wait_time = wait_times[randi() % wait_times.size()]
	
	if !is_slime_chase:
		# สุ่มทิศทาง
		dir = directions[randi() % directions.size()]
		#print("ทิศทางใหม่: ", dir) # <-- เอาไว้ทดสอบ

# ฟังก์ชันนี้จะทำงานเมื่อมี "body" เข้ามาใน Area2D
func _on_DetectionRadius_body_entered(body):
	# เช็กว่า body ที่เข้ามา อยู่ใน Group "player" หรือไม่
	if body.is_in_group("player"):
		player = body
		is_slime_chase = true
		is_roaming = false
		# print("เจอผู้เล่น! เริ่มไล่ล่า")

# ฟังก์ชันนี้จะทำงานเมื่อ "body" ออกจาก Area2D
func _on_DetectionRadius_body_exited(body):
	if body.is_in_group("player"):
		player = null
		is_slime_chase = false
		is_roaming = true
		# print("ผู้เล่นหนีไปแล้ว! กลับไปเดินสุ่ม")
