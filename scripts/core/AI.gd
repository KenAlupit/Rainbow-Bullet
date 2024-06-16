extends Node
class_name RainbowAI

static func _precalculate_ray_coordinates(_max_view_distance = 1500.0, coordinates = [deg2rad(60.0), deg2rad(10.0)]):
	var cast_vectors = []
	var cast_count = int(coordinates[0] / coordinates[1]) + 1
	
	for index in cast_count:
		var cast_vector: Vector2 = (
		_max_view_distance
		* Vector2.UP.rotated(coordinates[1] * (index - cast_count / 2.0))
		)
		cast_vectors.append(cast_vector)
	
	return cast_vectors

