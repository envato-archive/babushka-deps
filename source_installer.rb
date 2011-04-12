require 'fileutils'
class SourceInstaller < Tango::Runner
  def initialize
    @apt = AptInstaller.new
  end

  step 'install' do |source_url|
    @apt.install('build-essential')
    cd '/tmp' do
      FileUtils.rm_f(File.join('/tmp/', File.basename(source_url)))
      shell('wget', source_url).succeeded? or raise("curl failed to download #{source_url}")
      shell('tar', '-xvzf', File.basename(source_url))
      cd File.basename(source_url, '.tar.gz') do
        shell('./configure').succeeded? && shell('make').succeeded? && shell('make install')
        shell('ldconfig')
      end
    end
  end
end
