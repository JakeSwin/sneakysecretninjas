extends Area3D

func _on_body_entered(body: Node3D) -> void:
	if body.name == "NinjaCollider":
		SignalBus.emit_signal("seen_by", 1)

func _on_body_exited(body: Node3D) -> void:
	if body.name == "NinjaCollider":
		SignalBus.emit_signal("seen_by", -1)
