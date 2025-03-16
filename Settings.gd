extends Node
class_name settings

static var NUMBER_WAVES = 4
static var current_wave = 1

# Default Player & Bullet Settings
static var PLAYER_HEALTH = 5
static var PLAYER_SPEED = 150.0
static var PLAYER_ACCEL = 2.0

static var BULLET_SPEED = 600.0
static var NORMAL_SHOT : float = 0.5
static var FAST_SHOT : float = 0.1

static var ENEMY_SPEED = 200.0
static var ENEMY_ACCEL = 2.0
static var ENEMY_DAMAGE = 1.0
static var NUMBER_ENEMIES = 5

# Wave-Specific Settings
static var WAVE_CONFIGS = {
	1: { "ENEMY_SPEED": 200, "NUMBER_ENEMIES": 5, "PLAYER_HEALTH": 5 },
	2: { "ENEMY_SPEED": 220, "NUMBER_ENEMIES": 10, "PLAYER_HEALTH": 6 },
	3: { "ENEMY_SPEED": 250, "NUMBER_ENEMIES": 15, "PLAYER_HEALTH": 7 },
	4: { "ENEMY_SPEED": 300, "NUMBER_ENEMIES": 20, "PLAYER_HEALTH": 8 }
}

# Function to Update Settings for Current Wave
static func apply_wave_settings(wave_number):
	if current_wave in WAVE_CONFIGS:
		current_wave = wave_number
		var wave_data = WAVE_CONFIGS[current_wave]
		ENEMY_SPEED = wave_data["ENEMY_SPEED"]
		NUMBER_ENEMIES = wave_data["NUMBER_ENEMIES"]
		PLAYER_HEALTH = wave_data["PLAYER_HEALTH"]
