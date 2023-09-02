/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./src/index.html", "./src/**/*.{js,ts,jsx,tsx}"],
  theme: {
    fontFamily: {
      sans: ["IBM Plex Mono", "monospace"],
    },
    extend: {},
  },
  plugins: [],
  darkMode: "class",
};
