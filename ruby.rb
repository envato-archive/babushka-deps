# Choose your ruby version to install. Do this early

dep 'correct ruby version installed' do
  define_var :ruby_type, :default => 'mri'
  setup {
    case var(:ruby_type)
    when 'mri'
      set :bin_path, '/usr/bin'
    when 'mri-fast'
      requires 'mri fast.src'
      set :bin_path, '/usr/local/bin'
    when 'ree'
      requires 'ree.src'
      set :bin_path, '/usr/local/bin'
    else
      raise "Invalid ruby_type '#{var(:ruby_type)}', choose either 'mri', 'mri-fast' or 'ree'."
    end
  }
end

dep 'mri fast.src' do
  requires 'zlib headers.managed'
  requires %w(libreadline5 libreadline5-dev libncurses5 libncurses5-dev libssl-dev).map {|i| dep("#{i}.managed") { provides [] } }
  source "ftp://ftp.ruby-lang.org//pub/ruby/ruby-1.8.7-p299.tar.gz"
  configure_env "CFLAGS='-fno-strict-aliasing -Os -fPIC' LD_RUN_PATH='/usr/local/lib'"
  configure_args '--prefix=/usr/local', '--libdir=/usr/local/lib', '--disable-maintainer-mode', '--disable-dependency-tracking', '--disable-silent-rules',
    '--disable-pthread', '--disable-debug', '--enable-shared', '--disable-socks', '--enable-ipv6', '--with-lookup-order-hack=INET',
    '--disable-rpath', '--disable-install-doc', '--with-default-kcode=none', '--with-dbm-type=gdbm_compat', '--with-openssl', '--with-tklib=tk8.4',
    '--with-tcllib=tcl8.4', '--with-bundled-sha1', '--with-bundled-md5', '--with-bundled-rmd160', '--enable-option-checking=no'
  after { sudo('ldconfig') } # Recache ld.so.cache, it seems to be out of date and doesn't include /usr/local/lib
  met? { shell("ruby --version") =~ /1\.8\.7.*patchlevel 299/ }
end

dep 'ree.src' do
  source "http://rubyforge.org/frs/download.php/71098/ruby-enterprise_1.8.7-2010.02_amd64_ubuntu10.04.deb"
  process_source {
    sudo("dpkg -i ruby-enterprise_1.8.7-2010.02_amd64_ubuntu10.04.deb")
  }
  met? { shell("ruby --version") =~ /#{Regexp.escape("ruby 1.8.7 (2010-04-19 patchlevel 253) [x86_64-linux], MBARI 0x6770, Ruby Enterprise Edition 2010.02")}/ }
  after {
    #kill REE default gems
    %w[rack actionmailer actionpack activerecord activeresource activesupport fastthread mysql passenger pg rails rake sqlite3-ruby].each { |gem_to_uninstall|
      failable_shell "sudo gem uninstall #{gem_to_uninstall} -axI", :log => true
    }
  }
end
