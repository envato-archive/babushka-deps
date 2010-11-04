dep 'webserver capable of starting' do
  requires 'nginx installed.src', #DONE
           'www user and group', #DONE
           'webserver startup script.nginx' #DONE
  define_var :nginx_prefix, :default => '/opt/nginx'
end

dep 'nginx running', :template => 'benhoskings:nginx' do
  define_var :nginx_prefix, :default => '/opt/nginx'
  met? {
    returning nginx_running? do |result|
      log "There is #{result ? 'something' : 'nothing'} listening on #{result ? result.scan(/[0-9.*]+[.:]80/).first : 'port 80'}"
    end
  }
  meet do
    sudo "#{var(:nginx_prefix)}/sbin/nginx"
  end
end
