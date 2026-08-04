import { defineConfig } from "vite";
import ViteRails from "vite-plugin-rails";
import inject from "@rollup/plugin-inject";

export default defineConfig({
  plugins: [
    inject({
      $: "jquery",
      jQuery: "jquery",
      popper: ["popper.js", "default"],
      include: ["**/*.js"],  // Only apply to JavaScript files
      exclude: ["**/*.scss", "**/*.css"], // Exclude SCSS and CSS files
    }),
    ViteRails(),
  ],
  server: {
    // In Docker the Rails dev-server proxy forwards asset requests to this
    // dev server using the compose service hostname (e.g. "vite"), which
    // Vite 5's DNS-rebinding protection blocks with a 403. This is a
    // local-only dev server, so allow any host.
    allowedHosts: true,
  },
  build: {
    chunkSizeWarningLimit: 1000,  // Increase chunk size warning limit (in kB)
  },
});
