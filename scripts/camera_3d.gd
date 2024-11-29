extends Camera3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.connect("swapping", swapcam)
	SignalBus.connect("leaderswap", swappus)
	SignalBus.connect("gobackiwanttobemonke", mmmmonke)
	$"../../Control".visible = false

func swapcam():
	$".".current = true
	$"../../CameraPivot2/Camera3D".current = false
	$"../../CameraPivot3/Camera3D".current = false
	$"../../Control".visible = true
	await get_tree().create_timer(2).timeout
	$"../../Control".mouse_filter = Control.MOUSE_FILTER_IGNORE

func swappus():
	$"../../CameraPivot2/Camera3D".current = true
	$"../../CameraPivot3/Camera3D".current = false
	$".".current = false
	$"../../Leaderboard".visible = true

func mmmmonke():
	$"../../CameraPivot3/Camera3D".current = true
	$".".current = false
	$"../../CameraPivot2/Camera3D".current = false
	$"../../Leaderboard".visible = false
