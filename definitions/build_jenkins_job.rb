define :build_jenkins_job, :delete => false, :config_path => '/etc/jenkins_jobs/jenkins_jobs.ini' do

  if !params.has_key?(:job_config) or params[:job_config].nil? or params[:job_config].empty?
    Chef::Log.fatal("build_jenkins_job: no job_config parameter provided for #{params[:name]}")
    raise
  end

  unless params[:delete]
    ruby_block "update #{params[:name]} job config" do
      block do
        Chef::Log.info("build_jenkins_job: updating jobs from #{params[:job_config]}")
        update_job = Chef::ShellOut.new("jenkins-jobs --conf #{params[:config_path]} update #{params[:job_config]}").run_command
        Chef::Log.debug("build_jenkins_job: " + update_job.format_for_exception)
        unless update_job.status == 0
          Chef::Log.fatal('build_jenkins_job: error updating job: ' + update_job.format_for_exception)
          raise
        end
      end
    end
  else
    ruby_block "delete #{params[:name]} job config" do
      block do
        Chef::Log.info("build_jenkins_job: deleting job #{params[:name]}")
        delete_job = Chef::ShellOut.new("jenkins-jobs --conf #{params[:config_path]} delete #{params[:name]}").run_command
        Chef::Log.debug("build_jenkins_job: " + delete_job.format_for_exception)
        unless delete_job.status == 0
          Chef::Log.fatal('build_jenkins_job: error deleting job: ' + delete_job.format_for_exception)
          raise
        end
      end
    end
  end
end