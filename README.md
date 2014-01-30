# jenkins-job-builder

The OpenStack [jenkins-job-builder](https://github.com/openstack-infra/jenkins-job-builder) project provides a very useful tool that enables storing Jenkins job configuration as code.

This cookbook installs and configures jenkins-job-builder, as well as providing a `build_jenkins_job` definition which runs jenkins-job-builder against a given file or directory.

## Dependencies

This cookbook depends on the opscode python cookbook for installation of jenkins-job-builder via pip. The jenkins-job-builder software will not be very useful to you without a Jenkins server to talk to.

## Attributes

The following attributes are used for setting directory and file ownership 
* jenkins_job_builder.user
* jenkins_job_builder.group

The following attributes are used to generate the config file in '/etc/jenkins_jobs'
* jenkins_job_builder.username
* jenkins_job_builder.password
* jenkins_job_builder.url

## Definition usage

Although this cookbook can be used stand-alone to simply install jenkins-job-builder, 
it is intended for use within an application or wrapper cookbook for automating the 
configuration of your Jenkins server.

For example, you may create your own examplecorp-jenkins-jobs cookbook with a recipe for the `widget` project:

```ruby
include_recipe 'jenkins'
include_recipe 'jenkins_job_builder'

template '/opt/examplecorp-jenkins-jobs/widget.yaml' do
  # derp derp de derp
end

build_jenkins_job 'widget' do
  job_config '/opt/examplecorp-jenkins-jobs/widget.yaml'
end
```

This would effectively install the jenkins server, install jenkins-job-builder, create a jenkins-job-builder yaml file from template and update the Jenkins server configuration with that yaml file. 

The `build_jenkins_job` definition accepts the following parameters:
* `job_config` -- path to a file or directory that `jenkins-job update` should be run against (required)
* `config_path` -- path to the config file that `jenkins-job` should be run with (defaults to '/etc/jenkins_jobs/jenkins_jobs.ini') 
* `delete` -- boolean which controls whether or not to delete the named job (defaults to false)

## Caveats

Because jenkins-job-builder maintains its own internal cache representing the state of configured jobs, we depend on the accuracy of that cache for idempotency. 

Just as with jenkins-job-builder itself, this cookbook assumes jobs will be managed only via jenkins-job-builder, all changes made via the web will be lost. You may wish to put a message to this effect in your jenkins job descriptions.

## Changelog

