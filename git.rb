# General tasks for manipulating a remote git repo. Say, with your codes in it.

dep 'dir exists as a git repo' do
  requires 'git'
  met? { (var(:repo) / '.git').dir? }
  meet {
    in_dir var(:repo), :create => true do
      shell "git init"
    end
  }
end

dep 'tracking branch up-to-date' do
  requires 'add remote and switch to tracking branch'
  met? { in_dir(var(:repo)) {
    shell "git fetch #{var(:remote)}"
    shell("cat .git/refs/heads/#{var(:branch)}") == shell("cat .git/refs/remotes/#{var(:remote)}/#{var(:branch)}")
  } }
  meet { in_dir(var(:repo)) { shell "git merge --ff-only #{var(:remote)}/#{var(:branch)}" } }
end

dep 'add remote and switch to tracking branch' do
  define_var :repo, :default => ".", :message => "Path to local repo"
  define_var :remote, :message => "Name of remote repo"
  define_var :branch, :message => "Branch to track"
  met? {
    in_dir(var(:repo)) {
      current_branch = shell("git branch")[/^\*\W*(\w+)/, 1]
      current_branch == var(:branch)
    }
  }
  meet {
    in_dir(var(:repo)) {
      if shell("git branch")[/#{var(:branch)}/]
        #better than this, surely?
        raise "Branch #{var(:branch)} already exists!"
      end
      shell("git remote add #{var(:remote)} #{var(:remote_url)}")
      shell("git fetch #{var(:remote)}")
      shell("git checkout -f -b #{var(:branch)} #{var(:remote)}/#{var(:branch)}", :log => true)
    }
  }
end
