dep 'time zone set' do
  met? { grep Regexp.new(Regexp.escape(var(:timezone, :default => "Australia/Melbourne"))), "/etc/timezone" }
  meet {
    if ('/usr/share/zoneinfo' / var(:timezone)).exists?
      sudo "echo '#{var(:timezone)}' > /etc/timezone"
      sudo "dpkg-reconfigure --frontend noninteractive tzdata"
    else
      log_error "Timezone #{var(:timezone)} is not valid! Check what is in /usr/share/zoneinfo"
    end
  }
end
