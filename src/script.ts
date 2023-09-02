import * as THREE from "three";

import f from "./frags/calibrate.glsl?raw";

const vertexShader = `
precision mediump float; 
varying vec2 vUv;
                     
void main() {
vUv = uv;
gl_Position = projectionMatrix * modelViewMatrix *    vec4(position, 1.0);
}`;

const fs = `
#ifdef GL_ES
precision highp float;
#endif

#define PI2 6.28318530718
#define MAX_ITER 5

uniform float iTime;
uniform vec2 iResolution;
uniform vec2 iMouse;
uniform vec3 iColor;
uniform float spectrum;

${f}

void main( void ) {
  mainImage(gl_FragColor, gl_FragCoord.xy);
}
`;

class CustomScene {
  private scene!: THREE.Scene;
  private camera!: THREE.PerspectiveCamera;
  private geometry!: THREE.PlaneGeometry | THREE.BoxGeometry;
  private light!: THREE.SpotLight;
  private material!: THREE.ShaderMaterial;
  private mesh!: THREE.Mesh;
  private renderer!: THREE.WebGLRenderer;
  private clock!: THREE.Clock;

  private canvas!: HTMLCanvasElement;

  public init(canvas: HTMLCanvasElement) {
    this.canvas = canvas;

    this.scene = new THREE.Scene();
    this.scene.background = new THREE.Color(0xe3e3e3);
    this.light = new THREE.SpotLight(0xffffff, 1);

    const resolution = this.resolution();

    this.camera = new THREE.OrthographicCamera(
      -resolution.width / 2,
      resolution.width / 2,
      resolution.height / 2,
      -resolution.height / 2,
      1,
      1000
    );

    this.geometry = new THREE.PlaneGeometry(
      resolution.width,
      resolution.height
    );
    this.material = new THREE.ShaderMaterial({
      vertexShader,
      fragmentShader: fs,
      uniforms: {
        iTime: { value: 0.0 },
        iResolution: {
          value: {
            x: resolution.width,
            y: resolution.height,
          },
        },
        iMouse: { value: { x: 0, y: 0 } },
        iColor: { value: new THREE.Color(0xffffff) },
      },
    });
    this.mesh = new THREE.Mesh(this.geometry, this.material);

    this.renderer = new THREE.WebGLRenderer({
      canvas: canvas,
      antialias: true,
    });
    this.renderer.setClearColor(0xffffff, 1);

    this.renderer.setPixelRatio(window.devicePixelRatio);

    this.renderer.setSize(
      resolution.width / window.devicePixelRatio,
      resolution.height / window.devicePixelRatio,
      false
    );

    this.scene.add(this.camera);
    this.scene.add(this.mesh);
    this.scene.add(this.light);
    this.mesh.position.set(0, 0, 0);
    this.camera.position.set(0, 0, 1);

    this.light.lookAt(this.mesh.position);
    this.camera.lookAt(this.mesh.position);

    this.clock = new THREE.Clock();

    this.addEvents();
  }

  public run() {
    window.requestAnimationFrame(this.run.bind(this));
    this.material.uniforms.iTime.value = this.clock.getElapsedTime();
    this.renderer.render(this.scene, this.camera);
  }

  private addEvents(): void {
    window.addEventListener("resize", this.onResize.bind(this), false);
  }

  private onResize() {
    const { width, height } = this.resolution();

    this.material.uniforms.iResolution = {
      value: { x: width, y: height },
    };
    this.camera.aspect = width / height;
    this.camera.updateProjectionMatrix();
    this.renderer.setSize(
      width / window.devicePixelRatio,
      height / window.devicePixelRatio,
      false
    );
  }

  private resolution() {
    const { width, height } = this.canvas.getBoundingClientRect();
    return {
      width: width,
      height: height,
    };
  }
}
const scene = new CustomScene();
scene.init(document.getElementById("canvas") as HTMLCanvasElement);
scene.run();
