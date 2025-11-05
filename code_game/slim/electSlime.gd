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

const LUNGE_JUMP_FORCE = 300
const LUNGE_SPEED = 350
var is_lunging = false
var has_dealt_damage_this_lunge = false

const speed = 50
var velocity = Vector2()
var dir = Vector2.RIGHT
const gravity = 900
var knockback_force = 200
var knockback_vertical_force = 150
var is_roaming = true

var wait_times = [1.5, 2.0, 2.5]
var directions = [Vector2.RIGHT, Vector2.LEFT]

func _ready():
	#เชื่อมต่ออันตโนมือ
	randomize()
	$DirectionTimer.start()
	$detectradius.connect("body_entered", self, "_on_DetectionRadius_body_entered")
	$detectradius.connect("body_exited", self, "_on_DetectionRadius_body_exited")
	$DamageCooldownTimer.connect("timeout", self, "_on_DamageCooldownTimer_timeout")
	$LungeDelayTimer.connect("timeout", self, "_on_LungeDelayTimer_timeout")

func _physics_process(_delta):
	#ระบบฟิสิกส์สุดมัน
	if !is_on_floor() or is_lunging:
		velocity.y += gravity * _delta
	else:
		velocity.y = 0 
	
	move() 
	handle_animation()
	velocity = move_and_slide(velocity, Vector2.UP)

func move():
	#เดิน
	if dead:
		velocity.x = 0
		return
	if is_lunging:
		if is_on_floor() and velocity.y > 0:
			is_lunging = false
			velocity.x = 0
			$DamageCooldownTimer.start()
		return

	if is_dealing_damage:
		velocity.x = 0
		return

	if is_slime_chase:
		if player != null:

			var direction_to_player = (player.global_position - global_position).normalized()
			if direction_to_player.x != 0:
				dir.x = sign(direction_to_player.x)

			velocity.x = direction_to_player.x * speed

		else:
			is_slime_chase = false
	else:

		is_roaming = true
		velocity.x = dir.x * speed

func handle_animation():
	var anim_sprite = $AnimatedSprite
	var flip = (dir.x == 1)

	if is_dealing_damage:
		anim_sprite.play("atk")
		anim_sprite.speed_scale = 4.0
		anim_sprite.flip_h = flip
		return

	if is_lunging:
		anim_sprite.play("walk")
		anim_sprite.speed_scale = 1.5
		anim_sprite.flip_h = flip
		return

	if !dead and !taking_damage:
		anim_sprite.speed_scale = 1.0
		if velocity.x != 0:
			anim_sprite.play("walk")
		else:
			anim_sprite.play("idel")
		anim_sprite.flip_h = flip

func _on_DirectionTimer_timeout():
	#เดินมั่วถ้าไม่ได้ตี
	if !is_slime_chase and !is_lunging:
		$DirectionTimer.wait_time = wait_times[randi() % wait_times.size()]
		dir = directions[randi() % directions.size()]

func _on_DetectionRadius_body_entered(body):
	#ระยะการมองเห็นของสไลม์
	if body.is_in_group("player"):
		player = body
		is_slime_chase = true
		is_roaming = false

		if $DamageCooldownTimer.is_stopped() and !is_lunging:
			$DamageCooldownTimer.start()

func _on_DetectionRadius_body_exited(body):
	#ออกจากการตรวจจับนะควัฟ
	if body.is_in_group("player"):
		player = null
		is_slime_chase = false
		is_roaming = true

		$DamageCooldownTimer.stop()
	
		$LungeDelayTimer.stop()
		is_dealing_damage = false

func _on_DamageCooldownTimer_timeout():
	#รอเวลาค่อยพุ่งนะจ๊ะ
	if player != null and !is_lunging and !is_dealing_damage:

		is_dealing_damage = true
		has_dealt_damage_this_lunge = false

		$LungeDelayTimer.start()

func _on_LungeDelayTimer_timeout():
	#ดีเลย์พุ่ง

	if player == null: 
		is_dealing_damage = false
		return
		
	is_dealing_damage = false
	is_lunging = true

	var direction_to_player = (player.global_position - global_position).normalized()
	velocity.x = direction_to_player.x * LUNGE_SPEED
	velocity.y = -LUNGE_JUMP_FORCE
	dir.x = sign(velocity.x)

func _on_Hitbox_body_entered(body):
	#hitbox
	if body.is_in_group("player") and is_lunging and !has_dealt_damage_this_lunge:
		has_dealt_damage_this_lunge = true 

		if body.has_method("take_damage"):
			body.take_damage(damage_to_deal)
	if body.has_method("apply_knockback"):
			var knockback_vector = Vector2(dir.x * knockback_force, -knockback_vertical_force)
			body.apply_knockback(knockback_vector)

func _on_AnimatedSprite_animation_finished():
	pass

func take_damage(player):

	PlayerData.heart -= 1
	PlayerData.heart = max(PlayerData.heart, 0)
	for gui in get_tree().get_nodes_in_group("GUI"):
		gui.update_hearts()
	if PlayerData.heart <= 0:
		player.die()
