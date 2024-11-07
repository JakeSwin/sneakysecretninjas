extends CSGSphere3D

@export var target_node: Node3D
var lerp_weight = 0.1
var moving: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.connect("move_player_to", move)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if moving:
		position = position.lerp(target_node.global_position + Vector3(0, 0, 0.8), lerp_weight)
		if position.distance_to(target_node.global_position + Vector3(0, 0, 0.8)) < 0.17:
			moving = false
	else:
		position = target_node.global_position + Vector3(0, 0, 0.8)

func move(object: Node3D):
	target_node = object
	moving = true
