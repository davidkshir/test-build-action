shader_type spatial;
render_mode blend_mix, cull_disabled;

group_uniforms Grid;
uniform float grid_size = 0.05;
uniform vec4 line_color : source_color = vec4(0.212, 0.345, 0.537, 1.0);
uniform float line_thickness : hint_range(0.001, 0.2) = 0.05;

group_uniforms Mask;
uniform vec3 mask_origin = vec3(0.0);
uniform float mask_radius = 1.0;
uniform float mask_feather = 0.5;

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

	float dist = distance(local_position, mask_origin);
	float mask = 1.0 - smoothstep(mask_radius - mask_feather, mask_radius, dist);

	ALBEDO = line_color.rgb;
	ALPHA = is_line * mask * line_color.a;
	EMISSION = line_color.rgb * 1.5;
}