include_recipe 'python'

yaml = value_for_platform_family({
  ['debian'] => 'libyaml-dev',
  ['rhel','fedora','suse'] => 'libyaml'
})

package yaml do
  action :install
end

ohai "python-version" do
  plugin "python"
  action :reload
end

if Gem::Version.new(node['languages']['python']['version']) < Gem::Version.new("2.7")
  python_pip "argparse"
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
    :external_url => node['jenkins']['server']['url'],
    :hipchat_token => node['jenkins_job_builder']['hipchat_token']
  })
end
