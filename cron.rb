# Add lines to your crontab!
#
# But not really! More like throw away your crontab and replace
# it with this, unless all the commands exist in it. oh, and we
# dont care about schedules. Sounds cleverer than it is.
#
# example:
#
# dep 'my crontab configured', :template => 'envato:crontab' do
#   env_vars_to_add lambda { ['MAILTO=bob@example.com', 'SOMETHING_ELSE=wow'] }
#   lines_to_add lambda {[
#     ["* * * * *", "#{var(:bin_path)}/ruby path/to/your/file.rb"],
#     ["*/5 * * * *", "#{var(:bin_path)}/ruby path/to/another/file.rb"],
#   ]}
# end

meta :crontab do
  accepts_list_for :env_vars_to_add # babushka puts my list in a list, how helpful. hence my use of first later on. I'll fix this when we switch to tango
  accepts_list_for :lines_to_add

  template {
    helper(:existing_crontab) { shell "crontab -l" }

    met? {
      existing_crontab &&
      lines_to_add.all? { |lines| lines.all? { |schedule, command|
        existing_crontab.include? command
      }} &&
      env_vars_to_add.first.all? { |declaration|
        existing_crontab.include? declaration
      }
    }
    meet {
      shell("crontab -", :input => "#{env_vars_to_add.join("\n")}\n\n#{lines_to_add.map { |lines| lines.map { |schedule, command| "#{schedule}   #{command}" }.join("\n") }.join("\n")}\n")
    }
  }
end
