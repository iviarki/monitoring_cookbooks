if platform?("debian","ubuntu")
  Chef::Log.info("FreeSpaceMonitor: Installing CLI tools on Debian Based Distro")

  remote_file "/tmp/get-pip.py" do
    source "https://bootstrap.pypa.io/get-pip.py"
  end

  execute 'pip install' do
    cwd '/tmp'
    command "python get-pip.py"
  end
end

Chef::Log.info("FreeSpaceMonitor: Creating Alarm")
execute 'create alarm' do
    command "aws cloudwatch put-metric-alarm --alarm-name '#{node[:stack][:name]}-#{node[:instance][:hostname]}-UtilizedSpace' --alarm-description 'Utilized Space exceeds 90% on root on #{node[:instance][:aws_instance_id]}' --metric-name DiskSpaceAvailable --namespace 'Linux System' --statistic Maximum --period 300 --threshold 90 --comparison-operator GreaterThanThreshold --dimensions Name=InstanceId,Value=#{node[:instance][:aws_instance_id]} --evaluation-periods 1 --alarm-actions #{node[:opsworks][:snsarn]} --unit Percent --region #{node[:instance][:aws_instance_id]}"
end
