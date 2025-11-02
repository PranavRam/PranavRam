/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./lib/**/*.ex",
    "./lib/**/*.heex",
    "./_pages/**/*.md",
    "./_posts/**/*.md"
  ],
  darkMode: "class",
  theme: {
    extend: {
      typography: {
        DEFAULT: {
          css: {
            pre: {
              backgroundColor: "#22272e",
            },
            'h1': {
              marginBottom: '0',
            },
            'h3': {
              marginBottom: '0',
            },
            'p': {
              marginTop: '0.5rem',
              marginBottom: '0.5rem',
            },
          },
        },
      },
    },
  },
  plugins: [
    require('@tailwindcss/typography'),
  ],
}
