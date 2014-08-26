Chef::Log.info("FreeSpaceMonitor: Install Packages")
package "perl-Switch"
package "perl-Sys-Syslog"
package "perl-LWP-Protocol-https"

remote_file "/tmp/CloudWatchMonitoringScripts-v1.1.0.zip" do
  source "http://ec2-downloads.s3.amazonaws.com/cloudwatch-samples/CloudWatchMonitoringScripts-v1.1.0.zip"
end

bash "unzipScript" do
  code <<-EOS
  unzip /tmp/CloudWatchMonitoringScripts-v1.1.0.zip -d /etc
  EOS
end

file "/tmp/CloudWatchMonitoringScripts-v1.1.0.zip" do
  action :delete
end

Chef::Log.info("FreeSpaceMonitor: Add Cron Job")
cron "freespaceMetric" do
  minute "*/1"
  command "/etc/aws-scripts-mon/mon-put-instance-data.pl --disk-space-avail"
end
