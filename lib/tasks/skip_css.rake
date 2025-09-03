# Completely disable CSS and Tailwind build tasks in Docker
if ENV['SKIP_CSS_BUILD'] == 'true' || ENV['DISABLE_TAILWINDCSS'] == 'true'
  puts "🔥💀 BROTHERHOOD: Completely disabling all CSS build tasks for Docker 💀🔥"
  
  # Override ALL possible Tailwind and CSS tasks
  %w[
    tailwindcss:build
    tailwindcss:watch
    tailwindcss:install
    css:build
    css:install
    css:watch
  ].each do |task_name|
    Rake::Task.define_task(task_name) do
      puts "🔥 SKIPPED: #{task_name} - CSS already built via npm"
    end
  end
  
  # Override namespace-based tasks
  namespace :tailwindcss do
    task :build do
      puts "🔥 SKIPPED: tailwindcss:build - CSS already built via npm"
    end
    
    task :install do
      puts "🔥 SKIPPED: tailwindcss:install - Dependencies already installed"
    end
    
    task :watch do
      puts "🔥 SKIPPED: tailwindcss:watch - Not needed in Docker"
    end
  end
  
  namespace :css do
    task :build do
      puts "🔥 SKIPPED: css:build - CSS already built via npm"
    end
    
    task :install do
      puts "🔥 SKIPPED: css:install - Dependencies already installed"
    end
  end
end
