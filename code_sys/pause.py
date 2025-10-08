from godot import exposed
from godot.bindings import Control, ResourceLoader, Node2D
from godot import *

@exposed
class PauseMenu(Control):

	def _ready(self):
		self.main_container = self.find_node("MarginContainer")
		self.main_container.hide()  # ซ่อนตอนเริ่มเกม
		self.opt = self.find_node("Option_menu")
		self.opt.hide()
	


	def _process(self, delta):
		if self.get_tree().paused:
			self.main_container.show()
		else:
			self.main_container.hide()
			self.opt.hide()

	def _on_continue_pressed(self):
		self.get_tree().paused = False

	def _on_option_pressed(self):
		self.opt.show()
		self.vbox.hide()


	def _on_exit_pressed(self):
		self.get_tree().paused = False
		self.get_tree().change_scene("res://scene/mainmenu.tscn")
		

	
	
	


