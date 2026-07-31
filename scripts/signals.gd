extends Node

# Signals

# Pickups
# the target is the node to pickup
signal coin(value: int, node : Node2D)
signal key(nr: int)

# Portal
signal set_portal_state(portal_id: int)
signal portal(portal_id: int)

# Level 
signal next_level(level_id: int)

# Hud
signal restart
signal replay
