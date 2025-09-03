# Skip CSS build tasks when SKIP_CSS_BUILD is set
if ENV['SKIP_CSS_BUILD'] == 'true'
  puts "🔥💀 BROTHERHOOD: Overriding Tailwind CSS tasks for Docker build 💀🔥"
  
  # Override the main tailwindcss:build task
  namespace :tailwindcss do
    task :build do
      puts "🔥 Skipping tailwindcss:build - CSS already built via npm"
    end
  end
  
  # Override other CSS-related tasks  
  Rake::Task.define_task("css:build") do
    puts "🔥 Skipping css:build - Tailwind already built"
  end
  
  Rake::Task.define_task("css:install") do
    puts "🔥 Skipping css:install - Dependencies already installed"
  end
end
