extends Node3D
class_name SolarSystem

var bodies: Array

func _compare(a, b):
	if a.get_num_of_orbital_parents() < b.get_num_of_orbital_parents():
		return 1
	elif a.get_num_of_orbital_parents() > b.get_num_of_orbital_parents():
		return 0


func _ready():
	bodies = get_children().filter(func(child): return child is CelestialBody)
	bodies.sort_custom(_compare)
	for body in bodies:
		body.init()
	print_debug(bodies)