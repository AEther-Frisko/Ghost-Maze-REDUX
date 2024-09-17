class_name InteractionArea
extends Area3D

@export var action_name: String = "interact"

var interact: Callable = func():
	pass

func _on_body_entered(_body):
	# adds area to list of active areas
	InteractionManager.register_area(self)

func _on_body_exited(_body):
	# removes area from list of active areas
	InteractionManager.unregister_area(self)
