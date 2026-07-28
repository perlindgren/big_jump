extends Node

# Signals

# Pickups
signal coin(value: int)
signal key(nr: int)

# Portal
signal set_portal_state(portal_id: int)
signal portal(portal_id:int)

# Hud
signal restart
signal replay
