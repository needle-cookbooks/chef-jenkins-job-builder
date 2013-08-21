default['jenkins_job_builder']['user'] = 'nobody'
default['jenkins_job_builder']['group'] = value_for_platform_family(
  ['debian'] => "nogroup",
  ['rhel','fedora','suse'] => "nobody"
)
default['jenkins_job_builder']['username'] = String.new
default['jenkins_job_builder']['password'] = String.new
default['jenkins_job_builder']['url'] = 'http://jenkins.example.com'
default['jenkins_job_builder']['version'] = '0.4.0'
default['jenkins_job_builder']['from_source'] = nil
default['jenkins_job_builder']['repo'] = nil
default['jenkins_job_builder']['hipchat_token'] = nil
