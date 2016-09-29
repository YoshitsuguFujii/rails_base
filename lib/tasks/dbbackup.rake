require 'active_record'
require 'pry-byebug'

# schedule.rb setting example
# Thanks -> http://cobachie.hatenablog.com/entry/2015/05/19/100909
# every 1.day, :at => '3:30 am' do
#     backup_path = "tmp/backups"
#     rake "db:backup backup_path=#{backup_path}"
# end
#
namespace :db do
  # rake db:backup RAILS_ENV=production backup_path=tmp/backups
  desc "Dumps the database"
  task backup: [:environment, :load_config] do

    environment = Rails.env
    configuration = ActiveRecord::Base.configurations[environment]
    db_server =  configuration["host"] || "localhost"
    db_esc_path = ENV['backup_path'] # ファイルのバックアップ先のパス
    timestamp = Time.now.strftime("%Y-%m-%d_%H-%M-%S")
    backup_file = "#{db_esc_path}/#{timestamp}.dump"

    cmd = nil
    cmd = "MYSQL_PWD=#{configuration['password']} mysqldump -h #{db_server} -u #{configuration['username']} #{configuration['database']} > #{backup_file}"

    puts cmd
    exec cmd
  end
end
