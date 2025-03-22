extends Node
class_name settings

static var game_start = false

static var NUMBER_WAVES = 5
static var current_wave = 1

# Default Player & Bullet Settings
static var PLAYER_HEALTH = 3
static var PLAYER_SPEED = 100.0
static var PLAYER_ACCEL = 8
static var FRICTION = 10

static var BULLET_SPEED = 600.0
static var NORMAL_SHOT : float = 1
static var FAST_SHOT : float = 0.3

static var ENEMY_SPEED = 100.0
static var ENEMY_ACCEL = 2.0
static var ENEMY_DAMAGE = 1
static var NUMBER_ENEMIES = 10
static var SPAWN_INTERVAL = 1.0

static var DROP_RATE : float = 1

static var total_lives : int

# Wave-Specific Settings
static var WAVE_CONFIGS = {
	1: { "ENEMY_SPEED": 100, "NUMBER_ENEMIES": 5, "PLAYER_HEALTH": 3, "SPAWN_INTERVAL": 0.9 },
	2: { "ENEMY_SPEED": 112.5, "NUMBER_ENEMIES": 10, "PLAYER_HEALTH": 3, "SPAWN_INTERVAL": 0.8 },
	3: { "ENEMY_SPEED": 125, "NUMBER_ENEMIES": 15, "PLAYER_HEALTH": 3, "SPAWN_INTERVAL": 0.7 },
	4: { "ENEMY_SPEED": 150, "NUMBER_ENEMIES": 20, "PLAYER_HEALTH": 3, "SPAWN_INTERVAL": 0.6 },
	5: { "ENEMY_SPEED": 175, "NUMBER_ENEMIES": 25, "PLAYER_HEALTH": 3, "SPAWN_INTERVAL": 0.5 }
}

# Function to Update Settings for Current Wave
static func apply_wave_settings(wave_number):
	if current_wave in WAVE_CONFIGS:
		current_wave = wave_number
		var wave_data = WAVE_CONFIGS[current_wave]
		ENEMY_SPEED = wave_data["ENEMY_SPEED"]
		NUMBER_ENEMIES = wave_data["NUMBER_ENEMIES"]
		PLAYER_HEALTH = wave_data["PLAYER_HEALTH"]
		SPAWN_INTERVAL = wave_data["SPAWN_INTERVAL"]
		
		total_lives = PLAYER_HEALTH * wave_number
