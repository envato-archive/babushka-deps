require 'apt_installer'
require 'source_installer'

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
