# Installs and configures monit. Like a boss.
require 'apt_installer'

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

  step 'monit_running' do
    met? { shell("monit", "status").output.include?('uptime') }
    meet do
      install
      monit_startable
      shell("/etc/init.d/monit", "start")
    end
  end
#
  step 'monit_startable' do

   met? { shell("grep", "startup=1", "/etc/default/monit").succeeded? }
   meet do
     configure_monitrc
     configure
     shell("sed", "-i", "s/startup=0/startup=1/", "/etc/default/monit")
   end
  end
end
