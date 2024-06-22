extends StaticBody3D
class_name N_Body_Problem

@export var mass: float
@export var velocity: Vector3

const G = 1

func _init(position: Vector3=Vector3(), mass: float=0.0, velocity: Vector3=Vector3()):
    global_transform.origin = position
    self.mass = mass
    self.velocity = velocity

func calc_attraction(otherBodies: Array) -> Vector3:
    var total_force = Vector3()
    for body in otherBodies:
        if body != self:
            var r = body.global_transform.origin - global_transform.origin
            var distance = r.length()
            if distance != 0:
                var force_magnitude = G * self.mass * body.mass / pow(distance, 2)
                var force = r.normalized() * force_magnitude
                total_force += force
    return total_force

func update_velocity(delta: float, otherBodies: Array):
    var force = calc_attraction(otherBodies)
    var acceleration = force / self.mass
    self.velocity += acceleration * delta
    # print_debug(self.velocity)

func update_position(delta: float):
    global_transform.origin += self.velocity * delta