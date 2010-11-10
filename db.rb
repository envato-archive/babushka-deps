# A cut-down of benhoskings db setup deps. This is pretty specific to our
# needs: mysql, root user, no password.

dep 'mysql db created' do #DONE
  requires 'mysql.managed' #DONE
  setup {
    if (db_config = yaml(var(:rails_root) / 'config/database.yml')[var(:rails_env)]).nil?
      log_error "There's no database.yml entry for the #{var(:rails_env)} environment."
    else
      set :db_name, db_config['database']
    end
  }
  # figure out root passwords / users / etc later.
  met? { shell("echo 'SHOW DATABASES;' | mysql -u root").split("\n")[1..-1].any? {|l| /\b#{var :db_name}\b/ =~ l } }
  meet { shell "echo 'CREATE DATABASE #{var :db_name};' | mysql -u root" }
end

dep 'mysql.managed' do
  installs { via :apt, %w[mysql-server libmysqlclient16-dev] }
  provides 'mysql'
end

dep 'mysql2.gem' do
  requires 'mysql.managed'
  provides []
end
