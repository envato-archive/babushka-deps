require 'apt_installer'
require 'source_installer'

class ImageMagickInstaller < Tango::Runner
  def initialize
    @apt    = AptInstaller.new
    @source = SourceInstaller.new
  end

  step "install" do
    met? { shell("convert --version").succeeded? }

    meet do
      @apt.install "libjpeg62-dev"
      @apt.install "libpng12-dev"
      url = "http://downloads.sourceforge.net/project/imagemagick/old-sources/6.x/6.4/ImageMagick-6.4.9-10.tar.gz"
      @source.install(url, :configure_options => %w{--with-jpeg=yes --with-png=yes --with-perl=no})
    end
  end
end
