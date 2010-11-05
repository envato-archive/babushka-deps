dep 'haproxy', :template => 'managed'

dep 'haproxy running' do
  requires 'haproxy configured', 'haproxy startable'
  helper(:haproxy_pid) { "/var/run/haproxy.pid" }
  met? do
    haproxy_pid.p.exist? &&
    shell("ps `cat #{haproxy_pid}`")
  end
  meet { sudo "/etc/init.d/haproxy start" }
end

dep 'haproxy configured' do
  requires 'haproxy'

  define_var :app_name, :default => 'myapp'
  define_var :app_listen_port, :default => 8000
  define_var :stats_listen_port, :default => 8001
  define_var :number_of_upstream_mongrels, :default => 5
  define_var :mongrel_port_range, :default => '500x'
  define_var :max_connections, :default => 4096
  define_var :timeout, :default => 300000

  helper(:config_file) { "/etc/haproxy/haproxy.cfg" }
  met? { babushka_config? config_file }
  meet { render_erb "haproxy/haproxy.cfg.erb", :to => config_file, :sudo => true }
end

dep 'haproxy startable' do
  met? { sudo "grep 'ENABLED=1' /etc/default/haproxy" }
  meet { sudo "sed -i s/ENABLED=0/ENABLED=1/ /etc/default/haproxy" }
end
