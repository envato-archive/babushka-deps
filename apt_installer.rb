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
