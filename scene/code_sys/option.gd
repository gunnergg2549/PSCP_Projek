extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var panel = $Panel
var master_bus
var menu_music_bus
onready var menu_music_player = $Menu_MusicPlayer

# Called when the node enters the scene tree for the first time.
func _ready():

	master_bus = AudioServer.get_bus_index("Master")
	menu_music_bus = AudioServer.get_bus_index("Menu_Music")



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Back_pressed():
	var mainmenu = get_parent()      # parent คือ mainmenu ที่ใช้ Python
	var vbox = mainmenu.find_node("VBoxContainer")
	vbox.show()
	hide()



func _on_HSlider_value_changed(value: float):
	set_bus_volume(master_bus, value)
	$Panel/volume/HSlider/numvol.text = "%d%%" % int(value * 100)

func _on_HSlider2_value_changed(value: float):
	set_bus_volume(menu_music_bus, value)
	$Panel/music/HSlider2/numvol2.text = "%d%%" % int(value * 100)

	
func set_bus_volume(bus_index: int,value: float):
		AudioServer.set_bus_volume_db(bus_index, linear2db(value))
		AudioServer.set_bus_mute(bus_index,value < 0.01)

func stop_music():
	if menu_music_player.playing:
		menu_music_player.stop()
