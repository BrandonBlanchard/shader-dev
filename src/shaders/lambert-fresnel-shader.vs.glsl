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

#include <common>

void main () {
    v_mMatrix = modelMatrix;
    v_cameraPosition = cameraPosition;

    // calculate the fragment position in world space
    v_worldPos = position;
    v_eyeVector = vec3((modelViewMatrix * vec4(position, 1.0)) - viewMatrix * vec4(cameraPosition, 1.0)); // normalize(v_worldPos - cameraPosition); // Camera facing 

    // Calculate our world space normal
    v_worldNormal = normalize(normalMatrix * normal);

    vec4 mvPosition = modelViewMatrix * vec4(position, 1.0);
    
    gl_Position = projectionMatrix * mvPosition;
}