YAML.load(File.read(File.join(ENV["HOME"], ".env.yml"))).each{ |k,v| ENV[k] = v } if File.exist?(File.join(ENV["HOME"], ".env.yml"))
YAML.load(File.read(File.join(ENV["HOME"], ".env.local.yml"))).each{ |k,v| ENV[k] = v } if File.exist?(File.join(ENV["HOME"], ".env.local.yml"))

if defined? Rails
  unless ENV["RAILS_PROTECTED_DIR"]
    $stderr.puts "Warning: RAILS_PROTECTED_DIR is not set"
    ENV["RAILS_PROTECTED_DIR"] = Rails.root.join("protected").to_s 
  end

  unless ENV["RAILS_TMP_DIR"]
    $stderr.puts "Warning: RAILS_TMP_DIR is not set"
    ENV["RAILS_TMP_DIR"] = Rails.root.join("tmp").to_s 
  end
end

unless ENV["RAILS_REDIS_ADDRESS"]
  $stderr.puts "Warning: RAILS_REDIS_ADDRESS is not set"
  ENV["RAILS_REDIS_ADDRESS"] = "127.0.0.1:6379"
end
