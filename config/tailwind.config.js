const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    "./public/*.html",
    "./app/helpers/**/*.rb", 
    "./app/javascript/**/*.js",
    "./app/views/**/*.erb",
    "./app/views/**/*.html.erb",
    "./app/assets/stylesheets/**/*.css"
  ],
  safelist: [
    // Include common Tailwind classes to ensure they're always generated
    'bg-gradient-to-br',
    'from-gray-900',
    'via-gray-800', 
    'to-black',
    'flex',
    'justify-between',
    'items-center',
    'w-12',
    'h-12',
    'text-2xl',
    'bg-gray-700',
    'hover:bg-gray-600',
    // Add pattern-based classes
    {
      pattern: /bg-(gray|purple|emerald|green|blue)-(100|200|300|400|500|600|700|800|900)/,
    },
    {
      pattern: /text-(gray|purple|emerald|green|blue|white)-(100|200|300|400|500|600|700|800|900)/,
    },
    {
      pattern: /(w|h)-(1|2|3|4|5|6|8|10|12|16|20|24|32|40|48|56|64)/,
    },
    {
      pattern: /(p|m|px|py|mx|my|mt|mb|ml|mr)-(1|2|3|4|5|6|8|10|12|16|20|24|32)/,
    }
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
  ]
}
