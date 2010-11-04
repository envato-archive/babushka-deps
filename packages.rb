dep 'bundler.gem' do
  installs 'bundler' => '1.0.0.rc.5'
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
  installs 'rack' => '1.0.1'
  provides 'rackup'
end

dep 'ntp.managed' do
  provides 'ntpd'
end

dep 'rake.gem' do
  installs 'rake' => '0.8.7'
end