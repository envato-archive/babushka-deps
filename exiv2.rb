class AptInstaller < Tango::Runner
  def installed?(package)
    shell("dpkg-query", "--status", package, :echo => false).output !~ /not.installed|deinstall/
  end

  step "install" do |package|
    met? { installed?(package) }
    # Need to figure out how to make this non-interactive. See:
    # http://ubuntuforums.org/showthread.php?t=1218525
    meet { shell("apt-get", "install", "-y", package) }
  end
end

class SourceInstaller < Tango::Runner
  def initialize
    @apt = AptInstaller.new
  end

  step 'install' do |source_url|
    @apt.install('build-essential')
    cd '/tmp' do
      shell('wget', source_url).succeeded? or raise("curl failed to download #{source_url}")
      shell('tar', '-xvzf', File.basename(source_url))
      cd File.basename(source_url, '.tar.gz') do
        shell('./configure').succeeded? && shell('make').succeeded? && shell('make install')
        shell('ldconfig')
      end
    end
  end
end

class Exiv2Installer < Tango::Runner
  def initialize
    @apt = AptInstaller.new
    @src_installer = SourceInstaller.new
  end

  step "install" do #requires root
    met? { shell("exiv2 -V|head -n1").output.include?("exiv2 0.21.1") }
    meet do
      @apt.install('zlib1g-dev')
      @apt.install('libexpat1-dev')
      @src_installer.install('http://www.exiv2.org/exiv2-0.21.1.tar.gz')
    end
  end
end
