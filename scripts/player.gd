extends Node3D

@export var target_node: Node3D

@onready var alert_sound = $AudioStreamPlayer

var lerp_weight = 0.1
var moving: bool = false
var caught: bool = false
var visibility = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("Hiding")
	SignalBus.connect("move_player_to", set_move_target)
	SignalBus.connect("seen_by", change_visiblity)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if caught:
		return
	if moving:
		check_if_caught()
		move()
	else:
		# Follow Bush Position
		position = target_node.global_position + Vector3(0, 0, 0.8)

func set_move_target(object: Node3D):
	target_node = object
	moving = true
	$AnimationPlayer.play("Sneaking")

func change_visiblity(amount: int):
	visibility += amount

func check_if_caught():
	if visibility > 0:
		moving = false
		caught = true
		alert_sound.play()

func move():
	position = position.lerp(target_node.global_position + Vector3(0, 0, 0.8), lerp_weight)
	look_at(target_node.global_position + Vector3(0, 0, 0.8), Vector3.UP)
	check_target_reached()

func check_target_reached():
	if position.distance_to(target_node.global_position + Vector3(0, 0, 0.8)) < 0.17:
		moving = false
		$AnimationPlayer.play("Hiding")
		rotation = Vector3.ZERO
