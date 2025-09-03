# Configure Tailwind CSS for Rails

# Override the default Tailwind CSS paths for Rails
Rails.application.configure do
  # Set the correct input file path for Tailwind CSS
  config.tailwindcss.input_file = Rails.root.join("app/assets/stylesheets/application.tailwind.css")
  config.tailwindcss.output_file = Rails.root.join("app/assets/builds/tailwind.css")
end if defined?(TailwindCSS)
