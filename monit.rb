# Installs and configures monit. Like a boss.
require 'apt_installer'

# dep 'monit running' do #DONE
#   requires 'monit'
#   requires_when_unmet 'monit startable'
#   met? { (status = sudo("monit status")) && status[/uptime/] }
#   meet { sudo "/etc/init.d/monit start" }
# end
#
# dep 'monit startable' do
#   requires 'monitrc configured', 'monit config is where we expect'
#   met? { sudo "grep 'startup=1' /etc/default/monit" }
#   meet { sudo "sed -i s/startup=0/startup=1/ /etc/default/monit" }
# end

class MonitInstaller < Tango::Runner
  def initialize
    @apt = AptInstaller.new
  end

  step 'install' do
    @apt.install('monit')
    configure
    configure_monitrc
  end

  step 'configure' do
    met? { File.exist?("/etc/default/monit") }
    meet { write("/etc/default/monit", "echo startup=0") }
  end

  step 'configure_monitrc' do
    @monit_frequency = 30
    @monit_port = 9111
    @monit_included_dir = '/etc/monit/conf.d/*.monitrc'
    write "/etc/monit/monitrc", <<-ERB
      set daemon <%= @monit_frequency %>
      set logfile syslog facility log_daemon

      set httpd port <%= @monit_port %>
          allow localhost

      include <%= @monit_included_dir %>
    ERB
    shell "chmod", "700", "/etc/monit/monitrc"
  end
end
