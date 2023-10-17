# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

ruby_path = File.join(File.expand_path(File.join(File.dirname(__FILE__),'..')),'website_checker_headless.rb')

set :output, "~/cron_log.log"

every 3.minutes do
    #command "ruby /home/mar/repos/ruby_automation/website_checker_headless.rb"
    command "ruby #{ruby_path}"
end