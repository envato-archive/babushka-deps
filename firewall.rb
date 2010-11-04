dep 'firewall enabled' do
  requires_when_unmet 'firewall permits SSH'
  met? { sudo("ufw status")["Status: active"] }
  meet { sudo "ufw -f enable" }
end

dep 'firewall disabled' do
  requires_when_unmet 'firewall permits SSH'
  met? { sudo("ufw status")["Status: inactive"] }
  meet { sudo "ufw -f disable" }
end

dep 'firewall permits SSH' do
  # Sadly, can't figure out a way to test if UFW is permitting SSH without turning it on
  met? { @firewall_permits_ssh_run }
  meet {
    sudo "ufw allow ssh"
    @firewall_permits_ssh_run = true
  }
end
