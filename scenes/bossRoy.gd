extends AnimatedSprite2D

@onready var player: CharacterBody2D = $"../Player"
@onready var pattern_system: PatternSystem = $PatternSystem

enum Pattern { DIRECT, CIRCLE, SPIRAL }
var current_pattern: Pattern = Pattern.DIRECT
var pattern_shot_count: int = 0
var spiral_angle: float = 0.0
var spiral_shot_count: int = 0
var shoot_timer: float = 0.0
var last_pattern_cooldown: float = 0.5

# Enemy-specific pattern configuration
const PATTERN_CONFIG = {
	Pattern.DIRECT: { "bursts": 3, "cooldown": 0.5 },
	Pattern.CIRCLE: { "bursts": 1, "cooldown": 0.8 },
	Pattern.SPIRAL: { "bursts": 8, "cooldown": 0.1 }
}

func _ready():
	pattern_system.initialize(self, player)

func _process(delta):
	shoot_timer -= delta
	if shoot_timer <= 0:
		fire_current_pattern()
		advance_pattern_state()
		shoot_timer = last_pattern_cooldown if pattern_shot_count == 0 and current_pattern == Pattern.SPIRAL else PATTERN_CONFIG[current_pattern].cooldown
		last_pattern_cooldown = PATTERN_CONFIG[current_pattern].cooldown

func fire_current_pattern():
	match current_pattern:
		Pattern.DIRECT:
			pattern_system.execute_pattern("direct")
		
		Pattern.CIRCLE:
			pattern_system.execute_pattern("circle")
		
		Pattern.SPIRAL:
			var params = {
				"shot_count": spiral_shot_count,
				"current_angle": spiral_angle
			}
			pattern_system.execute_pattern("spiral", params)
			spiral_angle += PI / 6 * pattern_system.patterns_available["spiral"]["tightness"]
			spiral_shot_count += 1

func advance_pattern_state():
	pattern_shot_count += 1
	var current_config = PATTERN_CONFIG[current_pattern]
	
	if pattern_shot_count >= current_config.bursts:
		current_pattern = wrapi(current_pattern + 1, 0, Pattern.size())
		pattern_shot_count = 0
		if current_pattern == Pattern.SPIRAL:
			spiral_angle = 0.0
			spiral_shot_count = 0
