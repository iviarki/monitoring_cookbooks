if platform?("debian","ubuntu")
  package 'awscli'
end

Chef::Log.info("FreeSpaceMonitor: Creating Alarm")
execute 'create alarm' do
  command "aws cloudwatch put-metric-alarm --alarm-name '#{node[:opsworks][:stack][:name]}-#{node[:opsworks][:instance][:hostname]}-UtilizedSpace' --alarm-description 'Utilized Space exceeds 90% on root on #{node[:opsworks][:instance][:aws_instance_id]}' --metric-name DiskSpaceUtilization --namespace 'System/Linux' --statistic Maximum --period 300 --threshold 90 --comparison-operator GreaterThanThreshold --dimensions Name=InstanceId,Value=#{node[:opsworks][:instance][:aws_instance_id]} Name=MountPath,Value=/ Name=Filesystem,Value=/dev/xvda1 --evaluation-periods 1 --alarm-actions #{node[:opsworks][:snsarn]} --unit Percent --region #{node[:opsworks][:instance][:region]}"
end
