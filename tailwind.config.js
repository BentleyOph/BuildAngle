/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./app/views/**/*.html.erb",
    "./app/helpers/**/*.rb",
    "./app/assets/stylesheets/**/*.css",
    "./app/javascript/**/*.js"
  ],
  theme: {
    extend: {
      fontFamily: {
        'sans': ['Orbitron', 'system-ui', 'sans-serif'],
      }
    },
  },
  plugins: [
    require('daisyui')
  ],
  daisyui: {
    themes: ["light", "dark", "black"],
  },
}
