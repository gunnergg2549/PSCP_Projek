from godot import exposed
from godot.bindings import Control, ResourceLoader, Node2D
from godot import *

@exposed
class PauseMenu(Control):

	def _ready(self):
		self.main_container = self.find_node("MarginContainer")
		self.main_container.hide()  # ซ่อนตอนเริ่มเกม
		self.pause_mode = Node.PAUSE_MODE_PROCESS
		self.find_node("contiunue").connect("pressed", self, "_on_continue_pressed")
		self.find_node("option").connect("pressed", self, "_on_option_pressed")
		self.find_node("exit").connect("pressed", self, "_on_exit_pressed")


	def _process(self, delta):
		if self.get_tree().paused:
			self.main_container.show()
		else:
			self.main_container.hide()

	def _on_continue_pressed(self):
		self.get_tree().paused = False

	def _on_option_pressed(self):
		self.get_tree().paused = False
		self.get_tree().change_scene("res://scene/option.tscn")

	def _on_exit_pressed(self):
		self.get_tree().quit()
	
	
	


