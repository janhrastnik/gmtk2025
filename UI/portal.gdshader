shader_type canvas_item;

uniform vec4 color_accent : source_color = vec4(1.0, 1.0, 1.0, 1.0);       // white
uniform vec4 color_background : source_color = vec4(0.2, 0.4, 0.8, 1.0);   // nice blue
uniform float radius_outer : hint_range(0.0, 1.0) = 0.5;
uniform float radius_inner : hint_range(0.0, 1.0) = 0.0;
uniform float angle_size : hint_range(0, 1.0) = 0.1;
uniform int n_sections = 3;

uniform float section_curve : hint_range(0, 10.0) = 1.0;
uniform float spin_speed : hint_range(0, 3.0) = 1.0;

uniform float radius_softness = 0.02;
uniform float angle_softness = 0.1;


void fragment() {
    vec2 uv = UV;
	vec2 center = vec2(0.5, 0.5);
    float dist = distance(uv, center);
	float angle = atan(uv.y - center.y, uv.x - center.x) + PI - dist * section_curve + TIME * spin_speed;

	// --- Compute angular fade ---
	float section_size = 2.0 * PI / float(n_sections);
	float angle_in_section = mod(angle, section_size);

	float soft_angle = angle_size + angle_size * angle_softness;
	float mix_factor = 0.0;

	if (angle_in_section < angle_size) {
	    mix_factor = 1.0;
	} else if (angle_in_section < soft_angle) {
	    mix_factor = smoothstep(soft_angle, angle_size, angle_in_section);
	} else if (angle_in_section > (section_size - soft_angle)) {
	    mix_factor = smoothstep(soft_angle, angle_size, section_size - angle_in_section);
	} else {
	    mix_factor = 0.0;
	}

	// Compute radial fade alpha as before
	float soft_radius_outer = radius_outer * (1.0 + radius_softness);
	float soft_radius_inner = radius_inner * (1.0 - radius_softness);

	float radius_alpha = 0.0;
	if (radius_inner < dist && dist < radius_outer) {
	    radius_alpha = 1.0;
	} else if (radius_inner < dist && dist < soft_radius_outer) {
	    radius_alpha = smoothstep(soft_radius_outer, radius_outer, dist);
	} else if (soft_radius_inner < dist && dist < radius_outer) {
	    radius_alpha = smoothstep(soft_radius_inner, radius_inner, dist);
	} else {
	    radius_alpha = 0.0;
	}

	// Now blend colors based on angle mixing, but apply alpha from radial fade
	vec3 mixed_rgb = mix(color_background.rgb, color_accent.rgb, mix_factor);
	COLOR = vec4(mixed_rgb, radius_alpha);
}
