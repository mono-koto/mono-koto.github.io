/// <reference types="./vite-env-override.d.ts" />
/// <reference types="vite/client" />

declare module "*.glsl" {
  const value: string;
  export default value;
}
