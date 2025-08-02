extends Node

var world_tilemap: TileMapLayer = null
var world_camera: WorldCamera = null

signal global_events(event_name: String)
signal tilemap_loaded_event
signal loop_events
signal player_move_events
signal camera_move_events
signal prompt_events
