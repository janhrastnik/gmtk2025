extends Node2D

@onready var tilemap: TileMapLayer = $TileMapLayer

func _ready() -> void:
	GameData.world_tilemap = tilemap
