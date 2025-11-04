extends KinematicBody2D
class_name elec_slime

var is_slime_chase = false
var player = null

var health = 80
var dead = false

var is_attacking = false
var is_charging = false
var is_in_cooldown = false
var can_attack = true

const speed = 50
const gravity = 900
var velocity = Vector2()
var dir = Vector2.RIGHT

var roam_timer = 0.0
var roam_dir = 0

func _ready():
	randomize()
	$AnimatedSprite.connect("animation_finished", self, "_on_AnimatedSprite_animation_finished")
	$ChargeTimer.connect("timeout", self, "_on_ChargeTimer_timeout")
	$CooldownTimer.connect("timeout", self, "_on_CooldownTimer_timeout")
	$detectradius.connect("body_entered", self, "_on_detectradius_body_entered")
	$detectradius.connect("body_exited", self, "_on_detectradius_body_exited")
	$attackradius.connect("body_entered", self, "_on_attackradius_body_entered")
	$attackradius.connect("body_exited", self, "_on_attackradius_body_exited")
	roam_timer = rand_range(2.0, 4.0)

func _physics_process(delta):
	if !is_on_floor():
		velocity.y += gravity * delta
	else:
		if dead:
			velocity.x = 0
		elif is_charging or is_attacking:
			velocity.x = 0
		elif is_in_cooldown:
			velocity.x = 0
			$AnimatedSprite.play("afteratk")
		elif is_slime_chase and player:
			chase_player()
		else:
			roam(delta)

	# หมุน radius ตามทิศซ้ายขวาเท่านั้น
	var flip_dir = 1 if dir.x < 0 else -1
	$attackradius.scale.x = flip_dir
	$detectradius.scale.x = flip_dir

	velocity = move_and_slide(velocity, Vector2.UP)

# ------------------------
# Roam
# ------------------------
func roam(delta):
	roam_timer -= delta
	if roam_timer <= 0:
		roam_dir = rand_range(-1.0, 1.0)
		if abs(roam_dir) < 0.3:
			roam_dir = 0
		roam_timer = rand_range(2.0, 4.0)

	if roam_dir == 0:
		velocity.x = 0
		$AnimatedSprite.play("idle")
	else:
		dir.x = sign(roam_dir)
		velocity.x = dir.x * speed * 0.5
		$AnimatedSprite.play("walk")
		$AnimatedSprite.flip_h = dir.x > 0

# ------------------------
# Chase
# ------------------------
func chase_player():
	if !player:
		return
	var direction_to_player = (player.global_position - global_position).normalized()
	dir.x = sign(direction_to_player.x)
	velocity.x = direction_to_player.x * speed
	$AnimatedSprite.play("walk")
	$AnimatedSprite.flip_h = dir.x > 0

# ------------------------
# Damage
# ------------------------
func takedmg(dmg):
	health -= dmg
	if health <= 0 and !dead:
		dead = true
		$AnimatedSprite.play("dead")

# ------------------------
# Attack
# ------------------------
func start_charge():
	if !can_attack or is_attacking or is_charging or is_in_cooldown:
		return
	can_attack = false
	is_charging = true
	velocity.x = 0
	$AnimatedSprite.play("charge")
	$ChargeTimer.start()

func _on_ChargeTimer_timeout():
	is_charging = false
	is_attacking = true
	$AnimatedSprite.play("atk")

func _on_AnimatedSprite_animation_finished():
	match $AnimatedSprite.animation:
		"atk":
			is_attacking = false
			start_cooldown()
		"afteratk":
			is_in_cooldown = false
			can_attack = true

func start_cooldown():
	is_in_cooldown = true
	$AnimatedSprite.play("afteratk")
	$CooldownTimer.start()

func _on_CooldownTimer_timeout():
	is_in_cooldown = false
	can_attack = true

# ------------------------
# Detect player
# ------------------------
func _on_detectradius_body_entered(body):
	if body.is_in_group("player"):
		player = body
		is_slime_chase = true

func _on_detectradius_body_exited(body):
	if body.is_in_group("player"):
		player = null
		is_slime_chase = false
		_reset_attack_state()
		roam_timer = 0

# ------------------------
# Attack radius
# ------------------------
func _on_attackradius_body_entered(body):
	if body.is_in_group("player"):
		if can_attack:
			start_charge()

func _on_attackradius_body_exited(body):
	if body.is_in_group("player"):
		_reset_attack_state()

		# ถ้ายังเห็น player ให้วิ่งต่อ
		if is_slime_chase and player:
			chase_player()
		else:
			roam_timer = 0

# ------------------------
# Reset system
# ------------------------
func _reset_attack_state():
	is_attacking = false
	is_charging = false
	is_in_cooldown = false
	can_attack = true
	$ChargeTimer.stop()
	$CooldownTimer.stop()
	if !dead:
		$AnimatedSprite.play("idle")

# ------------------------
# Hitbox
# ------------------------
func _on_hitbox_area_entered(area):
	if area == Global.playerDamageZone:
		takedmg(Global.playerDamageAmount)


# เรียกตอนตีโดนผู้เล่น
func do_attack_hit():
	for body in $attackradius.get_overlapping_bodies():
		if body.is_in_group("player"):
			body.take_damage(self)



func _on_AnimatedSprite_frame_changed():
	if $AnimatedSprite.animation == "atk" and $AnimatedSprite.frame == 2:
		do_attack_hit()
