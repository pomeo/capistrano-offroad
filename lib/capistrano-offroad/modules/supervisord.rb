require 'capistrano'

Capistrano::Configuration.instance(:must_exist).load do
  set :supervisord_path, ""     # directory where supervisord binaries reside
  set :supervisord_command, "supervisord"
  set :supervisorctl_command, "supervisorctl"
  set :supervisord_pidfile, "supervisord.pid"
  set :supervisord_start_group, nil # process group to start on deploy:start - nil means all processes
  set :supervisord_stop_group, nil  # process group to stop on deploy:stop - nil means all processes

  namespace :deploy do
    def supervisord_pidfile_path ; "#{supervisord_pidfile}" end
    def supervisord_pid ; "`cat #{supervisord_pidfile_path}`" end

    # Run supervisorctl command `cmd'.
    def supervisorctl(cmd, options={})
      full_command = "#{sudo} #{supervisord_path}#{supervisorctl_command} #{cmd}"
      run full_command, options
    end

    def _target(var)
      group_name = ENV['GROUP']
      group_name ||= fetch var
      prog_name = ENV['PROGRAM']
      prog_name ||= 'all'

      if ['', nil].include? group_name then
        prog_name
      else
        "'#{group_name}:*'"
      end
    end

    desc "Start processes"
    task :start do
      to_start = _target(:supervisord_start_group)
      supervisorctl "start #{to_start}", :try_start => true
    end

    desc "Stop processes"
    task :stop do
      to_stop = _target(:supervisord_stop_group)
      supervisorctl "stop #{to_stop}", :try_start => false
    end

    desc "Restart processes"
    task :restart do
      to_restart = _target(:supervisord_start_group)
      supervisorctl "restart #{to_restart}"
    end

    desc "Display status of processes"
    task :status do
      supervisorctl "status", :try_start => false
    end

    desc "Display detailed list of processes"
    task :processes do
      run "test -f #{supervisord_pidfile_path} && pstree -a #{supervisord_pid}"
    end

    desc "Reload supervisor daemon"
    task :reload_supervisord do
      supervisorctl "reload"
    end

    task :run_supervisorctl do
      set_from_env_or_ask :command, "supervisorctl command: "
      supervisorctl "#{command}"
    end
  end
end
