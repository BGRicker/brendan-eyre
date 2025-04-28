const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './app/views/**/*.{erb,haml,html,slim}',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.{css,scss}',
    './app/javascript/**/*.{js,jsx,ts,tsx,vue}',
    './public/*.html',
    './config/initializers/**/*.rb',
    './lib/assets/**/*.{css,scss}',
    './lib/assets/**/*.{js,jsx,ts,tsx,vue}'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: [],
  corePlugins: {
    // Disable Tailwind's reset as we're using our own
    preflight: false,
  }
}
