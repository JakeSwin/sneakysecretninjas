extends Node3D

@export var target_node: Node3D
@export var camera_node: Camera3D

@onready var alert_sound = $AudioStreamPlayer
@onready var dash_particles: GPUParticles3D = $DashParticles
@onready var smoke_particles: GPUParticles3D = $SmokeParticles
@onready var smoke_particles_2: GPUParticles3D = $SmokeParticles2
@onready var smoke_particles_3: GPUParticles3D = $SmokeParticles3

var lerp_weight = 0.1
var moving: bool = false
var caught: bool = false
var visibility = 0
var ninja: Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("hide") # Hiding
	SignalBus.connect("move_player_to", set_move_target)
	SignalBus.connect("seen_by", change_visiblity)
	ninja = get_tree().get_nodes_in_group("ninja")[0]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if caught:
		look_at(Vector3(camera_node.global_position.x, 0, camera_node.global_position.z), Vector3.UP)
		return
	if moving:
		check_if_caught()
		move()
	else:
		# Follow Bush Position
		position = target_node.global_position + Vector3(0, 0, 0.8)

	if Global.smoked == true:
		var pos = smoke_particles.global_position
		pos.x = ninja.global_position.x
		pos.y = ninja.global_position.y + 1.5
		pos.z = ninja.global_position.z
		smoke_particles.global_position = pos
		pos.x += 0.2
		pos.y -= 0.25
		smoke_particles_2.global_position = pos
		pos.x -= 0.4
		smoke_particles_3.global_position = pos
		$SmokeParticles.emitting = true
		$SmokeParticles2.emitting = true
		$SmokeParticles3.emitting = true
	else:
		$SmokeParticles.emitting = false
		$SmokeParticles2.emitting = false
		$SmokeParticles3.emitting = false

func set_move_target(object: Node3D):
	target_node = object
	moving = true
	dash_particles.emitting = true
	#$AnimationPlayer.play("Sneaking")

func change_visiblity(amount: int):
	visibility += amount

func check_if_caught():
	if visibility > 0 and Global.smoked == false:
		moving = false
		caught = true
		dash_particles.emitting = false
		alert_sound.play()
		$AnimationPlayer.play("caught")
		SignalBus.emit_signal("caught", self)
		return

func move():
	position = position.lerp(target_node.global_position + Vector3(0, 0, 0.8), lerp_weight)
	look_at(target_node.global_position + Vector3(0, 0, 0.8), Vector3.UP)
	check_target_reached()

func check_target_reached():
	if position.distance_to(target_node.global_position + Vector3(0, 0, 0.8)) < 0.17:
		moving = false
		$AnimationPlayer.play("hide") # Hiding
		dash_particles.emitting = false
		rotation = Vector3.ZERO
		Global.smoked = false
