extends Path3D

@onready var path_follow_3d: PathFollow3D = $PathFollow3D
@onready var guard: Node3D = $"./PathFollow3D/guard"

var speed = 1

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	guard.stop_moving.connect(stop_moving)

func stop_moving():
	speed = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	path_follow_3d.progress += speed * delta
