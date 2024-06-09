@tool
extends TileMap

@export var __add_collision_to_tilemap: bool = false
@export var __tile_size: int = 32
@export var __sprite_sheet_size: Vector2 = Vector2(12, 4)

func _ready():
	if Engine.is_editor_hint and __add_collision_to_tilemap:
		__generate_collision()

func __generate_collision():
	for _x in __sprite_sheet_size.x:
		for _y in __sprite_sheet_size.y:
			var _shape = ConvexPolygonShape2D.new()
			_shape.points = [
				Vector2(0.0, 0.0),
				Vector2(0.0, __tile_size),
				Vector2(__tile_size, __tile_size),
				Vector2(__tile_size, 0.0)
			]
			tile_set.tile_add_shape(
				0,
				_shape,
				Transform2D(0.0, Vector2(0.0, 0.0)),
				false,
				Vector2(_x, _y)
			)
