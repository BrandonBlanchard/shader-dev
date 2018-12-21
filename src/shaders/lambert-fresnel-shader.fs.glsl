#if NUM_POINT_LIGHTS > 0

struct PointLight {
    vec3 position;
    vec3 color;
};

uniform PointLight pointLights [NUM_POINT_LIGHTS];
#endif

uniform bool Transparent;
uniform vec3 Color;
uniform float Albedo;

varying vec3 v_worldNormal;
varying vec3 v_eyeVector;
varying vec3 v_worldPos;
varying mat4 v_mMatrix;
varying vec3 v_cameraPosition;

const float M_PI = 3.1415926;
const vec3 ambientLight = vec3(0.05, 0.05, 0.05);

vec3 diffuseLighting (vec3 worldNorm, float lightIntensity, vec3 lightDirection, vec3 lightColor) {
    return (Albedo / M_PI * lightIntensity * lightColor * max(0.0, dot(worldNorm, lightDirection)));
}

float FresnelTransparency (vec3 normal, vec3 eyeDirection) {
    const float bias = 0.0;
    const float scale = 0.2;

    float IdotN = max(0.0, dot(eyeDirection, normal));
    return IdotN;
}

void main () {
    vec3 worldNorm = normalize(vec3(v_mMatrix * vec4(v_worldNormal, 0.0)));
    vec3 brightness = vec3(0,0,0);
    vec3 worldPos = (v_mMatrix * vec4(v_worldPos, 1.0)).xyz;
    float alpha = 1.0;

    // Loop through the available point lights and add thier lighting to the brightness model.
    for(int i = 0; i < NUM_POINT_LIGHTS; i += 1) {
        vec3 lightDirection = normalize(v_worldPos - pointLights[i].position); // surface to light

        // This is not a botched average, this is a janky intensity hack
        float intensity = (pointLights[i].color.r + pointLights[i].color.g + pointLights[i].color.b) / 0.3; 

        // Accumulate all our light into one model
        brightness += diffuseLighting(worldNorm, intensity, lightDirection, pointLights[i].color);
        
    }

    // Light zero corresponds with the keylight from our light rig. This may need modification if changes are made to the light rig.
    if(Transparent) {
        vec3 lightDirection = normalize(v_worldPos - pointLights[0].position); // surface to light
        alpha = (1.0 - FresnelTransparency(worldNorm, lightDirection));
    }

    gl_FragColor = vec4( ambientLight + brightness * Color, alpha);
}
