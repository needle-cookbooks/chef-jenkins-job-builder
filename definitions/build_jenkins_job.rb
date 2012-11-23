define :build_jenkins_job, :delete => false, :config_path => '/etc/jenkins_jobs/jenkins_jobs.ini' do

  if !params.has_key?(:job_config) or params[:job_config].nil? or params[:job_config].empty?
    Chef::Log.fatal("build_jenkins_job: no job_config parameter provided for #{params[:name]}")
    raise
  end

  unless params[:delete]
    Chef::Log.info("build_jenkins_job: updating jobs from #{params[:job_config]}")
    update_job = Chef::ShellOut.new("jenkins-jobs -c #{params[:config_path]} update #{params[:job_config]}").run_command
    Chef::Log.debug("build_jenkins_job: " + update_job.stderr.inspect)
  else
    Chef::Log.info("build_jenkins_job: deleting job #{params[:name]}")
    delete_job = Chef::ShellOut.new("jenkins-jobs -c #{params[:config_path]} delete #{params[:name]}").run_command
    Chef::Log.debug("build_jenkins_job: " + delete_job.stderr.inspect)
  end
end