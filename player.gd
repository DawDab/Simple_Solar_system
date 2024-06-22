extends RigidBody3D
class_name Player

@export var _camera: Camera3D
@export var _camera_pivot: Node3D
@export var _mouse_sensitivity: float = 0.08

var _mouse_delta: Vector2
var _camera_x_rotation: float
var _thrust: float = 20.0
var _in_map: bool

func _ready():
	_show_map(false)

func _process(delta):
	if(Input.is_action_just_released("Map")):
		_show_map(!_in_map)

func _show_map(in_map: bool):
	_in_map = in_map
	if(_in_map):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		_camera.current = false
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		_camera.current = true

func _physics_process(delta):
	_handle_movement(delta)
	_handle_look(delta)
	_mouse_delta = Vector2.ZERO

func _handle_movement(delta):
	var movement = Vector3.ZERO
	var forward = -global_transform.basis.z
	var left = -global_transform.basis.x
	if(Input.is_action_pressed("move_forward")): movement += forward
	if(Input.is_action_pressed("move_backward")): movement -= forward
	if(Input.is_action_pressed("move_left")): movement += left
	if(Input.is_action_pressed("move_right")): movement -= left
	if(movement != Vector3.ZERO):
		apply_central_force(_thrust * movement.normalized())

func _handle_look(delta):
	var delta_x = -_mouse_delta.y * _mouse_sensitivity
	var delta_y = -_mouse_delta.x * _mouse_sensitivity
	# rotate_y(-delta_y)  # Rotate the player horizontally
	rotate_object_local(Vector3.UP, deg_to_rad(delta_y))
	if (_camera_x_rotation + delta_x > -90 && delta_x < 90):
		_camera_pivot.rotate_x(deg_to_rad(delta_x))
		_camera_x_rotation += delta_x

func _input(event):
	if (event is InputEventMouseMotion):
		_mouse_delta += event.relative