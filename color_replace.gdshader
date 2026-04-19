shader_type canvas_item;

// The color in the texture you want to replace
uniform vec4 original_color : source_color = vec4(1.0, 0.0, 0.0, 1.0);

// The color you want to replace it with
uniform vec4 target_color : source_color = vec4(0.0, 1.0, 0.0, 1.0);

// How close a pixel's color must be to source_color to count as a match.
// 0.0 = exact match only, 1.0 = matches everything.
uniform float tolerance : hint_range(0.0, 1.0, 0.001) = 0.05;

// How soft the transition is around the edge of the match.
// 0.0 = hard swap, higher values blend nicely for anti-aliased edges.
uniform float softness : hint_range(0.0, 1.0, 0.001) = 0.02;

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);

	// Distance in RGB space between this pixel and the color we want to replace
	float dist = distance(tex_color.rgb, original_color.rgb);

	// 1.0 when the pixel matches, 0.0 when it doesn't, with a soft edge
	float match = 1.0 - smoothstep(tolerance, tolerance + softness, dist);

	// Blend toward target_color by the match amount, keep original alpha
	vec3 final_rgb = mix(tex_color.rgb, target_color.rgb, match);
	COLOR = vec4(final_rgb, tex_color.a);
}
