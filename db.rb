require 'apt_installer'
require 'gem_installer'
require 'yaml'

class MysqlInstaller < Tango::Runner
  def initialize
    @apt = AptInstaller.new
    @gem = GemInstaller.new
  end

  step 'mysql_db_created' do
    @rails_root = '/data/marketplace/current/'
    @rails_env = 'production'
    install_mysql
    db_config = YAML.load_file(File.join(@rails_root,'config/database.yml'))[@rails_env]

    if db_config.nil?
      raise "There's no database.yml entry for the #{@rails_env} environment."
    else
      @db_name = db_config['database']
    end

    raise "No database name was configured in database.yml" unless @db_name

    met? { shell("echo 'SHOW DATABASES;' | mysql -u root").output.split("\n")[1..-1].any? {|line| /\b#{@db_name}\b/ =~ line } }
    meet { shell("echo 'CREATE DATABASE #{@db_name};' | mysql -u root") }
  end

  step 'install_mysql' do
    %w[mysql-server libmysqlclient16-dev].each{|p| @apt.install(p) }
  end

  step 'install_mysql2_gem' do
    install_mysql
    @apt.install('ruby1.8-dev')
    @gem.install('mysql2')
  end
end
