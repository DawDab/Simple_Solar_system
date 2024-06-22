extends Node3D

var mouseSense := 0.01
var speed := 40.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_x(event.relative.y * mouseSense)
		rotate_y(-event.relative.x * mouseSense)

func _process(delta: float) -> void:
	var dir = Vector3.ZERO

	if Input.is_action_pressed("W"):
		dir -= transform.basis.z
	if Input.is_action_pressed("S"):
		dir += transform.basis.z
	if Input.is_action_pressed("A"):
		dir -= transform.basis.x
	if Input.is_action_pressed("D"):
		dir += transform.basis.x

	dir.y = 0  # Optional: Prevent vertical movement

	# Normalize direction vector to avoid faster diagonal movement
	if dir.length_squared() > 0:
		dir = dir.normalized() * speed * delta

		# Translate the Node3D (spectator camera)
		translate(dir)
