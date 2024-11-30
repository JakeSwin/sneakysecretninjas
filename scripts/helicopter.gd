extends Area3D

@onready var ninjav_2: Node3D = $"../ninjav2"

func _on_area_entered(area: Area3D) -> void:
	if area.name == "NinjaArea":
		SignalBus.emit_signal("caught", ninjav_2)
