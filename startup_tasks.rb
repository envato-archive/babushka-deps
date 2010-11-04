# If you need something done on startup on Ubuntu, like creating or chowning
# directories, throw a line in /etc/rc.local and profit!

meta :rc_local do
  accepts_list_for :lines_to_add
  template {
    helper(:rc_file) { "/etc/rc.local".p }
    met? { lines_to_add.all? { |line| grep line.to_s.chomp.strip, rc_file } }
    meet { insert_into_file "exit 0", rc_file, lines_to_add.join("\n") + "\n\n" }
    after { shell "sudo /etc/rc.local" }
  }
end

dep 'nginx upload dir created on boot', :template => 'rc_local' do
  lines_to_add L{"mkdir -p -m 777 #{var(:nginx_upload_dir)}"}
end

dep 'pid dir created on boot', :template => 'rc_local' do
  lines_to_add L{"mkdir -p #{var(:app_pid_dir)}"},
               L{"chown #{var(:app_name)}:#{var(:app_name)} #{var(:app_pid_dir)}"}
end
