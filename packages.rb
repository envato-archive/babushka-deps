dep 'bundler.gem' do
  installs 'bundler' => '1.0.7'
  provides 'bundle'
end

dep 'unzip.managed' do
  provides 'unzip',
           'zipinfo'
end

dep 'sysstat.managed' do
  provides 'mpstat'
end

dep 'nfs-common.managed' do
  provides []
end

dep 'scout.gem'
dep 'fastercsv.gem' do
  provides []
end

dep 'zip.managed'

dep 'rack.gem' do
  installs 'rack' => '1.1.0'
  provides 'rackup'
end

dep 'ntp.managed' do
  provides 'ntpd'
end

dep 'rake.gem' do
  installs 'rake' => '0.8.7'
end

dep 'nokogiri.gem' do
  requires 'libxslt-dev.managed', 'libxml.managed'
  provides []
end

dep 'libxslt-dev.managed' do
  installs { via :apt, 'libxslt1-dev' }
  provides []
end

dep 'libxml.managed' do
  installs { via :apt, 'libxml2-dev' }
  provides []
end

dep 'bash-completion.managed' do
  provides []
end
