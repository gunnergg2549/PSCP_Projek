extends StaticBody2D
export onready var animationPlayer = $atk/slimeanim
onready var gui = get_parent().get_node("GUI")
var can_damage = true
var damage_cooldown = 1.0  # หน่วง 1 วินาที

func _ready():
	animationPlayer.play("Idle")
	animationPlayer.playback_speed = 0.75


func _on_atk_body_entered(body):
	if body.name == "Player" and can_damage:
		take_damage(body)
				
				
func take_damage(player):
	PlayerData.heart -= 1
	PlayerData.heart = max(PlayerData.heart, 0)

	# อัปเดต GUI
	for gui in get_tree().get_nodes_in_group("GUI"):
		gui.update_hearts()

	if PlayerData.heart <= 0:
		player.die()

	can_damage = false
	yield(get_tree().create_timer(damage_cooldown), "timeout")
	can_damage = true
