shader_type canvas_item;

uniform vec3 light_blue = vec3(0.44, 0.78, 0.9);
uniform vec3 dark_blue = vec3(0.0, 0.14, 0.58);

void fragment(){
	float r = (1.0 + min(light_blue.r, dark_blue.r) + cos(TIME)*abs(light_blue.r-dark_blue.r))/2.0;
	float g = (1.0 + min(light_blue.g, dark_blue.g) + cos(TIME)*abs(light_blue.g-dark_blue.g))/2.0;
	float b = (1.0 + min(light_blue.b, dark_blue.b) + cos(TIME)*abs(light_blue.b-dark_blue.b))/2.0;
	
	COLOR = vec4(r, g, b, 1.0);
}
