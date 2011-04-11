class FirewallEnabler < Tango::Runner
  step "enable" do
    shell("ufw allow ssh") #always make sure we're not locking ourselves out
    met? { shell("ufw status").output.include?("Status: active") }
    meet { sudo("ufw -f enable") }
  end

  step "disable" do
    shell("ufw allow ssh") #always make sure we're not locking ourselves out
    met? { shell("ufw status").output.include?("Status: inactive") }
    meet { shell("ufw -f disable") }
  end
end
