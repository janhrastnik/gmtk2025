extends Node

var world_tilemap: TileMapLayer = null

signal global_events(event_name: String)
signal reset_events
signal loop_events
signal player_move_events
signal camera_move_events
