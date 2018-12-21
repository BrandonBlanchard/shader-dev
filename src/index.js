import Application3d from './classes/application-3d';
import * as three from 'three';

const app = new Application3d({ defaultScene: true });

// Load shader here and then use app.updateShaderMaterial to begin dev
import fresnelFS from './shaders/lambert-fresnel-shader.fs.glsl';
import fresnelVS from './shaders/lambert-fresnel-shader.vs.glsl';

app.updateShaders(fresnelFS, fresnelVS,  { uniforms: {
    Color: { type: 'c', value: new three.Color(0x24AEB4) },
    Transparent: { type:'bool', value: false },
    Albedo: { value: 0.24 }
}});