# Skip CSS build tasks when SKIP_CSS_BUILD is set
if ENV['SKIP_CSS_BUILD'] == 'true'
  Rake::Task.define_task("css:build") do
    puts "🔥 Skipping CSS build - Tailwind already built"
  end
  
  Rake::Task.define_task("css:install") do
    puts "🔥 Skipping CSS install - Dependencies already installed"
  end
end
