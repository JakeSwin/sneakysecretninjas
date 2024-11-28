extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal stop_moving

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("walk")
	SignalBus.connect("caught", catch_player)

func catch_player(player_object):
	look_at(Vector3(player_object.global_position.x, 0, player_object.global_position.z), Vector3.UP)
	animation_player.play("catch")
	stop_moving.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
