from godot import exposed, export
from godot import *


@exposed
class option_menu(Control):

	# member variables here, example:
	a = export(int)
	b = export(str, default='foo')

	def _ready(self):
		"""
		Called every time the node is added to the scene.
		Initialization here.
		"""
		pass
		
	def _on_Back_pressed(self):
		self.get_tree().change_scene("res://scene/maingame.tscn")
		
