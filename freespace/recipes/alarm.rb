if platform?("debian","ubuntu")
  Chef::Log.info("FreeSpaceMonitor: Download CLI Tools for Debian Based Distro")
  remote_file "/tmp/awscli-bundle.zip" do
    source "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip"
  end

  Chef::Log.info("FreeSpaceMonitor: Unzip AWS CLI Tools")
  execute 'unzip tools' do
    command "unzip awscli-bundle.zip"
    cwd '/tmp' 
  end 

  execute 'install tools' do
    command "./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws"
    cwd '/tmp'
  end
end

Chef::Log.info("FreeSpaceMonitor: Creating Alarm")
execute 'create alarm' do
  command "aws cloudwatch put-metric-alarm --alarm-name '#{node[:opsworks][:stack][:name]}-#{node[:opsworks][:instance][:hostname]}-UtilizedSpace' --alarm-description 'Utilized Space exceeds 90% on root on #{node[:opsworks][:instance][:aws_instance_id]}' --metric-name DiskSpaceUtilization --namespace 'System/Linux' --statistic Maximum --period 300 --threshold 90 --comparison-operator GreaterThanThreshold --dimensions Name=InstanceId,Value=#{node[:opsworks][:instance][:aws_instance_id]} Name=MountPath,Value=/ Name=Filesystem,Value=/dev/xvda1 --evaluation-periods 1 --alarm-actions #{node[:opsworks][:snsarn]} --unit Percent --region #{node[:opsworks][:instance][:region]}"
end
