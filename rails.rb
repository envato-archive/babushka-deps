dep 'bundler installed' do
  requires 'bundler.gem', 'local gemdir writable'
  define_var :bundler_installed_locally, :default => 'n'
  define_var :bundle_into_vendor, :default => 'n'
  met? { in_dir(var(:rails_root)) { shell "bundle check", :log => true } }
  meet { in_dir(var(:rails_root)) { sudo "bundle install --without test,cucumber #{'--local' if var(:bundle_local).to_s =~ /^y/} #{'--path vendor/bundle' if var(:bundle_into_vendor).to_s =~ /^y/}", :log => true }}
end
