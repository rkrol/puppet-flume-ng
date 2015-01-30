class flume-ng (
    $flume_version = "1.5.2",
    $flume_home = "/opt/flume-ng",
    $flume_logs_dir = "/var/log/flume-ng/") {

  exec { "download_flume":
    command => "wget -O /tmp/flume.tar.gz http://mirror.switch.ch/mirror/apache/dist/flume/${flume_version}/apache-flume-${flume_version}-bin.tar.gz",
    path    => $path,
    unless  => "ls /opt | grep flume-${flume_version}",
  }

  exec { "unpack_flume" :
    command => "tar -zxf /tmp/flume.tar.gz -C /opt && mv /opt/apache-flume-${flume_version}-bin ${flume_home}-${flume_version}",
    path    => $path,
    creates => "${flume_home}-${flume_version}",
    require => Exec["download_flume"]
  }

  file { "${flume_home}-${flume_version}" :
    recurse => true,
    owner   => root,
    group   => root,
    require => Exec["unpack_flume"]
  }

  file { "/etc/profile.d/flume-ng.sh":
    content => template("flume-ng/etc/profile.d/flume-ng.sh.erb"),
    require => Exec["unpack_flume"];
  }

  file { "/etc/init.d/flume-ng-agent":
    content => template("flume-ng/etc/init.d/flume-ng-agent.erb"),
    require => Exec["unpack_flume"];
  }

  file { "${flume_home}-${flume_version}/conf/log4j.properties":
    content => template("flume-ng/log4j.properties.erb"),
    require => Exec["unpack_flume"];
  }

  file { "${flume_home}-${flume_version}/conf/flume-env.sh":
    source  => "puppet:///modules/flume-ng/flume-env.sh",
    owner   => root,
    require => Exec["unpack_flume"];
  }

  file { "/var/run/flume-ng" :
    recurse => true,
    owner   => root,
    group   => root,
    require => Exec["unpack_flume"]
  }

  file { "${flume_logs_dir}" :
    recurse => true,
    owner   => root,
    group   => root,
    require => Exec["unpack_flume"]
  }

}
