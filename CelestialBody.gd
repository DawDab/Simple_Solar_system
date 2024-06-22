extends StaticBody3D
class_name CelestialBody

@export_category("Orbit")
#Parent celestial body around which this body orbits
#Simplified 2 Body problem to make stable system 
@export var _OrbitalParent: CelestialBody
#Radius of the orbit around the orbital parent
@export var _orbital_radius: float
#Angle at which the body is placed in its orbit
@export var _orbital_angle: float

@export_category("Gravity")
#The radius of the celestial body's surface
@export var surface_radius: float
#The gravitational acceleration at the surface of the celestial body
@export var _surface_gravity: float

@export_category("Rotation")
#The length of a day on this celestial body
@export var _day_length: float
#Fixed day length equal to orbital period
@export var _tidally_locked: bool


var gravitional_param: float
var acceleration_by_gravity: Vector3

func _ready():
	gravitional_param = _surface_gravity * surface_radius * surface_radius

# Initialize the celestial body's position and velocity
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

# Calculate the acceleration due to gravity at a given position
func get_acceleration_at_position(input_position: Vector3) -> Vector3:
	var d = input_position - self.global_position
	return - d.normalized() * gravitional_param / d.length_squared()

# Calculate the orbital velocity at a given position
func get_orbital_velocity(input_position: Vector3) -> Vector3:
	var d = input_position - self.global_position
	var speed = sqrt(gravitional_param / d.length())
	var direction = d.normalized().cross(Vector3.UP)
	return direction * speed

# Calculate the orbital period
func get_orbital_period() -> float:
	return 2.0 * PI * sqrt(pow(_orbital_radius, 3) / _OrbitalParent.gravitional_param)

# Calculate the relative velocity to the surface at a given position
func get_relative_velocity_to_surface(input_position: Vector3, linear_velocity: float) -> Vector3:
	var body_speed = constant_linear_velocity
	var rotational_speed = constant_angular_velocity.cross(input_position - global_position)
	var relative_speed = linear_velocity - (body_speed + rotational_speed)
	return relative_speed

# Called every physics frame to update the body's position and velocity
func _physics_process(delta):
	if _OrbitalParent != null:
		acceleration_by_gravity = _OrbitalParent.get_acceleration_at_position(global_position) + _OrbitalParent.acceleration_by_gravity
		constant_linear_velocity += acceleration_by_gravity * float(delta)
		global_position += constant_linear_velocity * float(delta)
		# print_debug(constant_linear_velocity)
	global_rotation += constant_angular_velocity * float(delta)

# Get the number of orbital parents recursively
func get_num_of_orbital_parents() -> int:
	if _OrbitalParent == null:
		return 0;
	else:
		return _OrbitalParent.get_num_of_orbital_parents() + 1
