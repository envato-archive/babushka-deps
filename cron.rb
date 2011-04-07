# Add lines to your crontab!
#
# example:
#
# dep 'my crontab configured', :template => 'envato:crontab' do
#   lines_to_add L{[
#     ["* * * * *", "#{var(:bin_path)}/ruby path/to/your/file.rb"],
#     ["*/5 * * * *", "#{var(:bin_path)}/ruby path/to/another/file.rb"],
#   ]}
# end

meta :crontab do
  accepts_list_for :lines_to_add
  template {
    helper(:existing_crontab) { shell "crontab -l" }
    met? {
      debugger
      existing_crontab && lines_to_add.all? { |lines| lines.all? { |schedule, command|
        existing_crontab[command]
      }}
    }
    meet {
      shell("crontab -", :input => lines_to_add.map { |lines| lines.map { |schedule, command| "#{schedule}   #{command}" }.join("\n") }.join("\n") + "\n")
    }
  }
end
