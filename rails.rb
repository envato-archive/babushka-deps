# Installs gems using bundler

dep 'bundler installed' do #DONE
  requires 'bundler.gem' #DONE
  define_var :bundler_installed_locally, :default => 'n'
  define_var :bundle_into_vendor, :default => 'n'
  setup {
    if var(:bundle_into_vendor) !~ /^y/
      requires 'local gemdir writable'
    end
  }
  met? { in_dir(var(:rails_root)) { shell "bundle check", :log => true } }
  meet { in_dir(var(:rails_root)) {
    sudo "bundle install --without test,cucumber #{'--local' if var(:bundler_installed_locally).to_s =~ /^y/} #{'--path vendor/bundle' if var(:bundle_into_vendor).to_s =~ /^y/}", :log => true
  }}
end

# Copies the relevant database.yml file into place

dep 'rails app db yaml present' do #DONE
  helper(:db_yaml) { var(:rails_root) / "config" / "database.yml" }
  met? { db_yaml.exists? }
  meet { shell "ln -s #{var(:rails_root) / "config" / "database.*#{var(:rails_env)}*"} #{db_yaml}" }
end

# If you don't install gems within your app, you need to ensure to can write to ~/.gem

dep 'local gemdir writable' do #DONE
  helper(:local_path) { "~/.gem".p }
  met? { File.writable_real?(local_path) }
  meet {
    sudo "mkdir -p #{local_path}"
    sudo "chown #{var(:username)}:#{var(:username)} #{local_path}"
  }
end

# Ensure your whole app is chowned as your user

dep 'rails app chowned' do
  met? { @rails_app_chowned_run }
  meet {
    sudo "chown -R #{var(:username)}:#{var(:username)} #{var(:rails_root)}"
    @rails_app_chowned_run = true
  }
end
