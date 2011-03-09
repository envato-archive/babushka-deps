dep 'exiv2.src' do
  source "http://www.exiv2.org/exiv2-0.21.1.tar.gz"
  met? { shell("exiv2 -V|head -n1") =~ /#{Regexp.escape("exiv2 0.21.1")}/ }
end
