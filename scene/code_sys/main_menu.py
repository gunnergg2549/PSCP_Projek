from godot import exposed, export
from godot.bindings import Node2D, Panel, VBoxContainer
from godot import *


@exposed
class mainmenu(Control):

	# member variables here, example:
	a = export(int)
	b = export(str, default='foo')
	

	def _ready(self):
		self.panel = self.find_node("Panel")
		self.vbox = self.find_node("VBoxContainer")
		self.vbox.show()
		self.panel.hide()
		
		
	def _on_Play_pressed(self):
		self.get_tree().change_scene("res://scene/maingame.tscn")
	
	def _on_Quit_pressed(self):
		self.get_tree().quit() 
		print("quit")
		
	def _on_Option_pressed(self):
		self.panel.show()
		self.vbox.hide()
		
	def _on_Back_pressed(self):
		self.vbox.show()
		self.panel.hide()
