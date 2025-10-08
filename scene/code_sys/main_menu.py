from godot import exposed, export
from godot.bindings import Node2D, Panel, VBoxContainer, Control, AudioServer
from godot import *


@exposed
class mainmenu(Control):

	# member variables here, example:
	a = export(int)
	b = export(str, default='foo')
	

	def _ready(self):
		self.vbox = self.find_node("VBoxContainer")
		self.opt = self.find_node("Option_menu")
		self.vbox.show()
		self.opt.hide()
		self.menu_music_bus = AudioServer.get_bus_index("Menu_Music")

		
		
	def _on_Play_pressed(self):
		self.get_tree().paused = False
		AudioServer.set_bus_mute(self.menu_music_bus, True)
		self.get_tree().change_scene("res://scene/maingame.tscn")
	
	def _on_Quit_pressed(self):
		self.get_tree().quit() 
		print("quit")
		
	def _on_Option_pressed(self):
		self.opt.show()
		self.vbox.hide()
		
	
