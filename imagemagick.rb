require 'apt_installer'
require 'source_installer'
class ImageMagickInstaller < Tango::Runner
  def initialize
    @apt = AptInstaller.new
    @src_installer = SourceInstaller.new
  end

  step "install" do
    #%w(gcc perl pkg-config).map {|i| dep "#{i}.managed" }
    # libz-dev libltdl3-dev

    met? { File.exist?('/usr/local/bin/convert') }

    meet do
      %w[graphviz libperl-dev gs-gpl libjpeg62-dev libbz2-dev libtiff4-dev libwmf-dev libpng12-dev libx11-dev libxt-dev libxext-dev libxml2-dev libfreetype6-dev liblcms1-dev libexif-dev libjasper-dev].each do |pkg|
        @apt.install pkg
      end

      @src_installer.install "http://downloads.sourceforge.net/project/imagemagick/old-sources/6.x/6.4/ImageMagick-6.4.9-10.tar.gz"
    end
  end
end
