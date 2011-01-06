dep 'user exists with password and ssh authorized key' do
  define_var :home_dir_base, :default => "/home"
  requires 'user exists with password', #DONE
           'authorized key present for user' #DONE
end

dep 'authorized key present for user' do #DONE
  define_var :username, :default => shell("whoami")
  helper(:ssh_dir) { "#{var(:home_dir_base) / var(:username)}/.ssh" }
  met? { sudo "grep '#{var(:ssh_public_key)}' '#{ssh_dir}/authorized_keys'" }
  before { sudo "mkdir -p '#{ssh_dir}'; chmod 700 '#{ssh_dir}'" }
  meet { append_to_file var(:ssh_public_key), "#{ssh_dir}/authorized_keys", :sudo => true }
  after { sudo "chown -R #{var(:username)}:#{var(:username)} '#{ssh_dir}'; chmod 600 '#{ssh_dir}/authorized_keys'" }
end

dep 'dot files' do #DONE
  define_var :github_user, :default => "envato"
  define_var :dot_files_repo, :default => "dot-files"
  requires 'git',
           'curl.managed'
  met? { "~/.dot-files/.git".p.exists? }
  meet { shell %Q{curl -L "http://github.com/#{var :github_user}/#{var :dot_files_repo}/raw/master/clone_and_link.sh" | bash} }
end

dep 'user exists with password' do #DONE
  requires 'user exists' #DONE
  on :linux do
    met? { grep(/^#{var(:username)}:[^\*!]/, '/etc/shadow') }
    meet {
      sudo "echo -e '#{var(:password)}\n#{var(:password)}' | passwd #{var(:username)}"
    }
  end
end

dep 'user exists' do #DONE
  met? { grep(/^#{var(:username)}:/, '/etc/passwd') }
  meet {
    sudo "mkdir -p #{var :home_dir_base}" and
      sudo "groupadd -g #{var :fixed_uid_and_gid} #{var :username}" and
      sudo "useradd -m -s /bin/bash -b #{var :home_dir_base} -g #{var :username} -G admin -u #{var :fixed_uid_and_gid} #{var :username}" and
      sudo "chmod 701 #{var(:home_dir_base) / var(:username)}"
  }
end
