dep 'delayed job running' do
  requires 'daemons.gem', #DONE
           'delayed job monit configured' #DONE
  # can we check they're actually running?
end

dep 'delayed job monit configured' do
  helper(:monitrc) { "/etc/monit/conf.d/dj.#{var(:app_name)}.monitrc" }
  met? { sudo "grep 'Generated by babushka' #{monitrc}" }
  meet { render_erb "monit/dj.monitrc.erb", :to => monitrc, :sudo => true }
  after {
    sudo "monit reload"
    sudo "monit restart all -g dj_#{var(:app_name)}"
  }
end

dep 'daemons.gem' do
  provides []
end
