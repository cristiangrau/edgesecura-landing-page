import { defineConfig } from 'astro/config';
import tailwindcss from '@tailwindcss/vite';

export default defineConfig({
  site: 'https://edgesecura.com',
  vite: {
    plugins: [tailwindcss()],
  },
});
