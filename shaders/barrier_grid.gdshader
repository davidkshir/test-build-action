shader_type spatial;
render_mode blend_mix, cull_disabled;

group_uniforms Grid;
uniform float grid_size = 1.0;
uniform vec4 line_color : source_color = vec4(0.212, 0.345, 0.537, 1.0);
uniform float line_thickness : hint_range(0.001, 0.2) = 0.05;

group_uniforms Shimmer;
uniform vec3 shimmer_origin = vec3(0.0);
uniform float shimmer_width = 1.5;

group_uniforms Fringing;
uniform float fringe_strength : hint_range(0.0, 0.2) = 0.03;
uniform float fringe_frequency = 15.0;
uniform float fringe_speed = 3.0;

varying vec3 local_position;
varying vec3 local_normal;

void vertex() {
	local_position = VERTEX;
	local_normal = abs(NORMAL);
}

vec2 get_box_uv(vec3 pos, vec3 norm) {
	if (norm.x > max(norm.y, norm.z)) return pos.zy;
	if (norm.y > norm.z) return pos.xz;
	return pos.xy;
}

void fragment() {
	vec2 grid = fract(get_box_uv(local_position, local_normal) / grid_size);
	vec2 lines = step(line_thickness, grid);

	float is_line = 1.0 - min(lines.x, lines.y);

	float fringe = sin(dot(local_position, vec3(12.0, 14.0, 12.0)) + TIME * fringe_speed) * fringe_strength;
	float distance_from_center = abs(local_position.z - shimmer_origin.z) + fringe;
	float shimmer = smoothstep(shimmer_width, 0.0, distance_from_center);

	ALBEDO = line_color.rgb;
	ALPHA = is_line * shimmer * line_color.a;
	EMISSION = line_color.rgb * 1.5;
}