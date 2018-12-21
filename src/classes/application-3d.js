
import * as three from 'three';


export default class Application3d {
    constructor (options) {
        // initialize the 3d canvas
        this.scene = new three.Scene();
        this.camera = new three.PerspectiveCamera(75, window.innerWidth/ window.innerHeight, 0.1, 1000);
        this.renderer = new three.WebGLRenderer();
        
        this.renderer.setSize(window.innerWidth, window.innerHeight);
        document.querySelector('.application__container').appendChild(this.renderer.domElement);
        
        // Add Event listeners
        addEventListener("resize", this.onResize.bind(this));
        
        if(options.defaultScene) { this.populateDefaultScene(); }
        
        // Delta time initialization stuff
        this.clock = new three.Clock();
        
        this.renderLoop();
    }

    populateDefaultScene () {

        // Add the torus knot
        const geo =  new three.TorusKnotGeometry(10, 1.5, 300, 20, 10, 11);
        const mat = new three.MeshBasicMaterial({color: 0x343499 });

        this.knot = new three.Mesh(geo, mat);
        this.scene.add(this.knot);

        this.camera.position.z = -50;
        this.camera.lookAt(this.knot.position);

        // Add the lights
        const key = new three.PointLight(0xffffff, 1, 300);
        const fill = new three.PointLight(0x0000ff, 0.8, 300);
        const ambient = new three.PointLight(0xff3434, 0.6, 300);

        // Key: in front top left
        key.position.set(-75, 100, -50);
        // Fill: top front mid-right
        fill.position.set(75, 75, -35);
        // Ambient:
        ambient.position.set(20, -75, -15);

        // Add lights to scene
        this.scene.add(key);
        this.scene.add(fill);
        this.scene.add(ambient);

    }
    
    onResize () {
        this.renderer.setSize(window.innerWidth, window.innerHeight);
        this.camera.aspect = window.innerWidth/window.innerHeight;
    }

    updateShaders (fs, vs, opts = {}) {
        let uniforms = three.UniformsUtils.merge([three.UniformsLib.lights, opts.uniforms]);

        let mat = new three.ShaderMaterial({
            uniforms,
            vertexShader: vs,
            fragmentShader: fs,
            lights: true,
            flatShading: false,
            transparent: true
        });

        this.knot.material = mat;
    }

    update () {
        this.knot.rotateY(0.2 * this.deltaTime);
        this.knot.rotateX(0.1 * this.deltaTime);
    }

    
    renderLoop() {
        this.deltaTime = this.clock.getDelta();
        
        this.update();
        this.renderer.render(this.scene, this.camera);


        requestAnimationFrame(this.renderLoop.bind(this));
    }
}
