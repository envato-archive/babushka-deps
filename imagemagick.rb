dep 'imagemagick.src' do
  requires %w(gcc perl pkg-config).map {|i| dep "#{i}.managed" }
  # libz-dev libltdl3-dev
  requires(%w[graphviz libperl-dev gs-gpl libjpeg62-dev libbz2-dev libtiff4-dev libwmf-dev libpng12-dev libx11-dev libxt-dev libxext-dev libxml2-dev libfreetype6-dev liblcms1-dev libexif-dev libjasper-dev].map do |i|
    dep "#{i}.managed" do
      provides []
    end
  end)
  source "http://downloads.sourceforge.net/project/imagemagick/old-sources/6.x/6.4/ImageMagick-6.4.9-10.tar.gz"
  provides 'convert'
  after { sudo "ldconfig" }
end
