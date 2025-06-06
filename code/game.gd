extends Node2D

@onready var player = $Player
@onready var player_sprite = $Player/Sprite2D

@onready var tilemap = $TileMap

var has_key = false

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	var move_dir = Vector2i(0, 0)
	if Input.is_action_just_pressed("up"):
		move_dir = Vector2i.UP
	if Input.is_action_just_pressed("down"):
		move_dir = Vector2i.DOWN
	if Input.is_action_just_pressed("left"):
		move_dir = Vector2i.LEFT
		player_sprite.flip_h = true
	if Input.is_action_just_pressed("right"):
		move_dir = Vector2i.RIGHT
		player_sprite.flip_h = false
	
	if move_dir != Vector2i.ZERO:
		var tile_coords = world_to_tile(player.global_position)
		var new_coords = tile_coords + move_dir
		if can_move_into(new_coords):
			player.global_position = tile_to_world(new_coords)
			update_world()	
		
func can_move_into(coords):
	var tile_id = tilemap.get_cell_source_id(0, coords)
	var atlas_coords = tilemap.get_cell_atlas_coords(0, coords)
	if tile_id == -1: #empty
		return true
	elif atlas_coords.x == 1: #normal door
		tilemap.set_cell(0, coords, -1)
		return true
	elif atlas_coords.y == 1: #locked door
		if has_key:
			has_key = false
			tilemap.set_cell(0, coords, -1)
			return true
	return false
		

func update_world():
	print("updating")



func world_to_tile(world_position: Vector2) -> Vector2i:
	return tilemap.local_to_map(tilemap.to_local(world_position))

func tile_to_world(tile_position: Vector2i) -> Vector2:
	return tilemap.to_global(tilemap.map_to_local(tile_position))
