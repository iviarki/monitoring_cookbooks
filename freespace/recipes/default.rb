unless Dir.exist? "/etc/aws-scripts-mon"
  Chef::Log.info("FreeSpaceMonitor: Install Required Packages")
  if platform?('centos', 'redhat', 'fedora', 'amazon')
    package "perl-Switch"
    package "perl-Sys-Syslog"
    package "perl-LWP-Protocol-https"
  end

  if platform?("debian","ubuntu")
    package "unzip"
    package "libwww-perl"
    package "libcrypt-ssleay-perl"
    package "libswitch-perl"
  end

  Chef::Log.info("FreeSpaceMonitor: Getting Scripts")
  remote_file "/tmp/CloudWatchMonitoringScripts-v1.1.0.zip" do
    source "http://ec2-downloads.s3.amazonaws.com/cloudwatch-samples/CloudWatchMonitoringScripts-v1.1.0.zip"
  end

  Chef::Log.info("FreeSpaceMonitor: Unzip Scripts")
  bash "unzipScript" do
    code <<-EOS
      unzip /tmp/CloudWatchMonitoringScripts-v1.1.0.zip -d /etc
    EOS
  end

  Chef::Log.info("FreeSpaceMonitor: Clean up zip")
  file "/tmp/CloudWatchMonitoringScripts-v1.1.0.zip" do
    action :delete
  end
end

Chef::Log.info("FreeSpaceMonitor: Add Cron Job")
cron "freespaceMetric" do
  minute "*/5"
  command "/etc/aws-scripts-mon/mon-put-instance-data.pl --disk-space-util --disk-path=/"
end
