include_recipe 'python'

yaml = value_for_platform_family({
  ['debian'] => 'libyaml-dev',
  ['rhel','fedora','suse'] => 'libyaml-devel'
})

if platform_family?('rhel')
  include_recipe 'yum::epel'
end

package yaml do
  action :install
end

unless node['jenkins_job_builder']['from_source']
  python_pip 'jenkins-job-builder' do
    version node['jenkins_job_builder']['version']
    action :install
  end
else
  python_pip node['jenkins_job_builder']['repo'] do
    action :install
  end
end

directory '/etc/jenkins_jobs' do
  owner node['jenkins_job_builder']['user']
  group node['jenkins_job_builder']['group']
  mode '0750'
end

template '/etc/jenkins_jobs/jenkins_jobs.ini' do
  source 'jenkins_jobs.ini.erb'
  owner node['jenkins_job_builder']['user']
  group node['jenkins_job_builder']['group']
  mode '0640'
  variables({
    :username => node['jenkins_job_builder']['username'],
    :password => node['jenkins_job_builder']['password'],
    :url => node['jenkins_job_builder']['url'],
    :hipchat_token => node['jenkins_job_builder']['hipchat_token']
  })
end
