shader_type canvas_item;
uniform bool white;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	
	if (white) {
		COLOR = vec4(1.0, 1.0, 1.0, color.a);
	}
	else {
		COLOR = color;
	}
}