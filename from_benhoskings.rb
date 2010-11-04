# Deps reproduced from benhosking's repository, in order to remove the
# external dependency, as well as remove anything we didn't need.
# e.g. passenger, non-ubuntu deps

dep 'nginx installed.src' do
  requires 'pcre.managed', #DONE
           'libssl headers.managed', #DONE
           'zlib headers.managed' #DONE
  merge :versions, {:nginx => '0.7.65', :nginx_upload_module => '2.0.12'}
  source "http://nginx.org/download/nginx-#{var(:versions)[:nginx]}.tar.gz"
  extra_source "http://www.grid.net.ru/nginx/download/nginx_upload_module-#{var(:versions)[:nginx_upload_module]}.tar.gz"
  configure_args "--with-pcre", "--with-http_ssl_module",
                 "--add-module='../../nginx_upload_module-#{var(:versions)[:nginx_upload_module]}/nginx_upload_module-#{var(:versions)[:nginx_upload_module]}'"
  setup {
    prefix var(:nginx_prefix, :default => '/opt/nginx')
    provides var(:nginx_prefix) / 'sbin/nginx'
  }

  configure { log_shell "configure", default_configure_command, :sudo => Babushka::GemHelper.should_sudo? }
  build { log_shell "build", "make", :sudo => Babushka::GemHelper.should_sudo? }
  install { log_shell "install", "make install", :sudo => Babushka::GemHelper.should_sudo? }

  met? {
    if !File.executable?(var(:nginx_prefix) / 'sbin/nginx')
      unmet "nginx isn't installed"
    else
      installed_version = shell(var(:nginx_prefix) / 'sbin/nginx -V') { |shell| shell.stderr }.val_for('nginx version').sub('nginx/', '')
      if installed_version != var(:versions)[:nginx]
        unmet "an outdated version of nginx is installed (#{installed_version})"
      else
        met "nginx-#{installed_version} is installed"
      end
    end
  }
end

dep 'www user and group' do #DONE
  met? { grep(/^www:/, '/etc/passwd') and grep(/^www:/, '/etc/group') }
  meet {
    sudo "groupadd www"
    sudo "useradd -g www www -s /bin/false"
  }
end

dep 'webserver startup script' do
  requires 'webserver installed.src', #DONE
           'rcconf.managed' #DONE
  met? { shell("rcconf --list").val_for('nginx') == 'on' }
  meet {
    render_erb 'nginx/nginx.init.d.erb', :to => '/etc/init.d/nginx', :perms => '755', :sudo => true
    sudo 'update-rc.d nginx defaults'
  }
end

# packages

dep 'pcre.managed' do
  installs { via :apt, 'libpcre3-dev' }
  provides 'pcretest'
end

dep 'libssl headers.managed' do
  installs { via :apt, 'libssl-dev' }
  provides []
end

dep 'zlib headers.managed' do
  installs { via :apt, 'zlib1g-dev' }
  provides []
end

dep 'rcconf.managed' do
  installs { via :apt, 'rcconf' }
end
