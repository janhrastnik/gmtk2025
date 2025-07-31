extends Node

var world_tilemap: TileMapLayer = null

signal global_events(event_name: String)
signal reset_events(level_name: String)
signal loop_events
