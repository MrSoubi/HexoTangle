shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float speed = 0.02;
	
	vec3 red = vec3(237./256., 41./256., 57./256.);
	vec3 dark_blue = vec3(0., 35./256., 149./256.);
	vec3 light_blue = vec3(114./256., 119./256., 231./256.);
	vec3 green = vec3(105./256., 190./256., 40./256.);
	vec3 orange = vec3(237./256., 41./256., 57./256.);
	vec3 yellow = vec3(254./256., 203./256., 0.);
	
	vec3 color;
	
	float x = (sin(TIME*speed)*sin(TIME*speed) * 5.);
	
	if (x < 1.){
		color = mix(red, dark_blue, x);
	}
	if (x>= 1. && x < 2.){
		color = mix(dark_blue, light_blue, x-1.);
	}
	if (x >=2. && x < 3.){
		color = mix(light_blue, green, x-2.);
	}
	if (x >= 3. && x < 4.){
		color = mix(green, orange, x-3.);
	}
	if (x >= 4. && x < 5.){
		color = mix(orange, yellow, x-4.);
	}
	
	COLOR = vec4(color, 1.0);
}