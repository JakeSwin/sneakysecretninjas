extends CSGSphere3D

var target_position: Vector3
var lerp_weight = 0.1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target_position = position
	SignalBus.connect("move_player_to", move)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = position.lerp(target_position, lerp_weight)

func move(object: Node3D):
	target_position = object.position + Vector3(0, 0, 0.8)
