# Puppet: Flume NG

## Dependencies

java

## Usage

   	class {'flume-ng': 
		flume_home	=> '/opt/flume-ng',
		flume_version	=> '1.3.1',
		flume_logs_dir  => '/var/log/flume-ng'
	}

