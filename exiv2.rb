class CronicInstaller < Tango::Runner
  step "install" do
    met? { shell("exiv2 -V|head -n1").output.include?("exiv2 0.21.1") }
    meet {
      source_url = 'http://www.exiv2.org/exiv2-0.21.1.tar.gz'
      shell("rm", "-rf", "/tmp/exiv2")
      shell("mkdir", "-p", "/tmp/exiv2")
      shell("cd", "/tmp/exiv2")
      shell('wget', source_url).succeeded? or raise("curl failed to download #{source_url}")
      shell('tar', '-xvzf', File.basename(source_url))
      shell('make') && shell('make install')
      shell('ldconfig')
    }
  end
end
