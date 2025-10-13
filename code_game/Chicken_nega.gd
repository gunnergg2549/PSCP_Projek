extends KinematicBody2D

class_name Chicken
export (PackedScene) var projectile_scene
var can_shoot = true
var is_attacking = false

onready var sprite_orig_scale = $AnimatedSprite.scale
onready var gun_orig_scale = $GunPoint.scale
onready var hitbox_orig_scale = $Hitbox.scale
onready var detection_orig_scale = $Detectionzone.scale



const speed = 15
var is_chase: bool = true
var gravity = 450

var health = 30
var max_health = 30
var min_health = 0
var die: bool = false
var taking_dmg: bool = false
var is_dealing_dmg: bool = false

var velocity = Vector2.ZERO
var knock_back = -50
var is_roaming:bool = true
var dir = Vector2.RIGHT
var player = Global.playerbody
var player_in_area = false

func _process(delta):
	handle_animation()
	player = Global.playerbody

func _physics_process(delta):
	if !is_on_floor():
		velocity.y += gravity * delta

	if not is_attacking:   # ถ้าโจมตีอยู่ จะหยุด movement
		move(delta)
		
	velocity = move_and_slide(velocity, Vector2.UP)

	if player_in_area and can_shoot and !die and !taking_dmg and not is_attacking:
		shoot_at_player()

	
		
func move(delta):
	if die:
		velocity.x = 0
		return
	
	if is_attacking:
		velocity.x = 0
		return
	
	if is_chase:
		if player != null and !taking_dmg:
			var dir_to_player = position.direction_to(player.position) * speed
			velocity.x = dir_to_player.x
			dir.x = abs(velocity.x) / velocity.x
	else:
		# Roaming
		velocity.x = dir.x * speed



func _ready():
	yield(get_tree(), "idle_frame")  # รอให้ Player โหลดก่อน 1 เฟรม
	player = Global.playerbody
	dir = choose([Vector2.RIGHT, Vector2.LEFT])
	$directiontimer.start()
	$ShootTimer.start()


func _on_directiontimer_timeout():
	if !is_chase:  # ทำงานเฉพาะตอน roaming
		dir = choose([Vector2.RIGHT, Vector2.LEFT])
		velocity.x = 0
		update_direction()
	$directiontimer.start()  # รีสตาร์ท timer


func choose(array):
	array.shuffle()
	return array.front()
	
func handle_animation():
		if die:
			if is_roaming:
				is_roaming = false
				play_anim("die")
		elif taking_dmg:
			play_anim("hurt")
		elif is_dealing_dmg:
			play_anim("atk_shoot")
		else:
			play_anim("walk")
	
	# flip
		update_direction()
		
func handle_death():
	self.queue_free()

func _on_Hitbox_area_entered(area):
	var dmg = Global.playerDamageAmount
	if area == Global.playerDamageZone:
		takedmg(dmg)
func takedmg(damage):
	health -= damage
	taking_dmg = true
	if health <= min_health:
		health = min_health
		die = true
	print(str(self), "current health",health)
		


func _on_shoottimer_timeout():
	can_shoot = true

func shoot_at_player():
	if projectile_scene == null or !can_shoot or taking_dmg or die:
		return

	can_shoot = false
	is_chase = false
	is_attacking = true    # ✅ หยุดเดิน
	velocity.x = 0

	var anim = $AnimatedSprite
	anim.play("atk_charge")

	# รอชาร์จ animation
	yield(get_tree().create_timer(0.8), "timeout")

	# เล่น animation ยิง
	anim.play("atk_shoot")

	# spawn กระสุนตรงกับ animation shoot
	var bullet = projectile_scene.instance()
	get_parent().add_child(bullet)

	var gun = $GunPoint
	if gun == null:
		print("GunPoint missing!")
		return

	var shoot_dir = (player.position - gun.global_position).normalized()
	bullet.position = gun.global_position
	bullet.direction = shoot_dir

	# flip GunPoint ตามทิศ
	update_direction()

	# รอ animation ยิงจบก่อนกลับไปเดิน
	yield(anim, "animation_finished")
	anim.play("walk")

	is_attacking = false    # ✅ กลับไปเดิน
	is_chase = true
	$ShootTimer.start()



func _on_Detectionzone_body_entered(body):
	if body == Global.playerbody:
		player_in_area = true
		is_chase = true


func _on_Detectionzone_body_exited(body):
	if body == Global.playerbody:
		player_in_area = false
		is_chase = false
		$directiontimer.start()


var current_anim = ""
func play_anim(name):
	if current_anim != name:
		$AnimatedSprite.play(name)
		current_anim = name
		
func update_direction():
	$AnimatedSprite.scale = Vector2(sprite_orig_scale.x * dir.x, sprite_orig_scale.y)
	$GunPoint.scale = Vector2(gun_orig_scale.x * dir.x, gun_orig_scale.y)
	$Hitbox.scale = Vector2(hitbox_orig_scale.x * dir.x, hitbox_orig_scale.y)
	$Detectionzone.scale = Vector2(detection_orig_scale.x * dir.x, detection_orig_scale.y)

