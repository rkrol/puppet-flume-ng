class flume {
  $flume_home = "/opt/flume-ng"

  exec { "download_flume":
    command => "wget -O /tmp/flume.tar.gz http://apache.mirrors.timporter.net/flume/1.2.0/apache-flume-1.2.0-bin.tar.gz",
    path    => $path,
    unless  => "ls /opt | grep flume-1.2.0",
  }

  exec { "unpack_flume" :
    command => "tar -zxf /tmp/flume.tar.gz -C /opt  && mv /opt/apache-flume-1.2.0 ${flume_home}-1.2.0",
    path    => $path,
    creates => "${flume_home}-1.2.0",
    require => Exec["download_flume"]
  }

  file { "${flume_home}-1.2.0" :
    recurse => true,
    owner   => root,
    group   => root,
    require => Exec["unpack_flume"]
  }

  file {
    "/etc/profile.d/flume-ng.sh":
      source  => "puppet:///modules/flume/etc/profile.d/flume-ng.sh",
      require => Exec["unpack_flume"];

    "${flume_home}-1.2.0/conf/flume-env.sh":
      source  => "puppet:///modules/flume/flume-env.sh",
      require => Exec["unpack_flume"];
  }

}
