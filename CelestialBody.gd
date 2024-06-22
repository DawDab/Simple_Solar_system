extends StaticBody3D
class_name CelestialBody

@export_category("Orbit")
@export var _OrbitalParent: CelestialBody
@export var _orbital_radius: float
@export var _orbital_angle: float

@export_category("Gravity")
@export var surface_radius: float
@export var _surface_gravity: float

@export_category("Rotation")
@export var _day_length: float
@export var _tidally_locked: bool

var gravitional_param: float
var acceleration_by_gravity: Vector3

func _ready():
	gravitional_param = _surface_gravity * surface_radius * surface_radius

func init():
	if _OrbitalParent != null:
		global_position = _OrbitalParent.global_position + (Vector3.FORWARD * _orbital_radius).rotated(Vector3.UP, deg_to_rad(_orbital_angle))
		constant_linear_velocity = _OrbitalParent.constant_linear_velocity + _OrbitalParent.get_orbital_velocity(global_position)
	if _tidally_locked:
		_day_length = get_orbital_period()
	if _day_length == 0:
		constant_angular_velocity = Vector3.UP * 0
	else:
		constant_angular_velocity = Vector3.UP * - (2.0 * PI / _day_length)

func get_acceleration_at_position(input_position: Vector3) -> Vector3:
	var d = input_position - self.global_position
	return - d.normalized() * gravitional_param / d.length_squared()

func get_orbital_velocity(input_position: Vector3) -> Vector3:
	var d = input_position - self.global_position
	var speed = sqrt(gravitional_param / d.length())
	var direction = d.normalized().cross(Vector3.UP)
	return direction * speed

func get_orbital_period() -> float:
	return 2.0 * PI * sqrt(pow(_orbital_radius, 3) / _OrbitalParent.gravitional_param)

func get_relative_velocity_to_surface(input_position: Vector3, linear_velocity: float) -> Vector3:
	var body_speed = constant_linear_velocity
	var rotational_speed = constant_angular_velocity.cross(input_position - global_position)
	var relative_speed = linear_velocity - (body_speed + rotational_speed)
	return relative_speed

func _physics_process(delta):
	if _OrbitalParent != null:
		acceleration_by_gravity = _OrbitalParent.get_acceleration_at_position(global_position) + _OrbitalParent.acceleration_by_gravity
		constant_linear_velocity += acceleration_by_gravity * float(delta)
		global_position += constant_linear_velocity * float(delta)
		# print_debug(constant_linear_velocity)
	global_rotation += constant_angular_velocity * float(delta)

func get_num_of_orbital_parents() -> int:
	if _OrbitalParent == null:
		return 0;
	else:
		return _OrbitalParent.get_num_of_orbital_parents() + 1
