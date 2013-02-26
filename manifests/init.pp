class flume-ng (
    $flume_version = "1.3.1",
    $flume_home = "/opt/flume-ng) {

  exec { "download_flume":
    command => "wget -O /tmp/flume.tar.gz http://apache.mirrors.timporter.net/flume/${flume_version}/apache-flume-${flume_version}-bin.tar.gz",
    path    => $path,
    unless  => "ls /opt | grep flume-${flume_version}",
  }

  exec { "unpack_flume" :
    command => "tar -zxf /tmp/flume.tar.gz -C /opt && mv /opt/apache-flume-${flume_version} ${flume_home}-${flume_version}",
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

  file {
    "/etc/profile.d/flume-ng.sh":
      source  => "puppet:///modules/flume/etc/profile.d/flume-ng.sh",
      require => Exec["unpack_flume"];

    "${flume_home}-${flume_version}/conf/flume-env.sh":
      source  => "puppet:///modules/flume/flume-env.sh",
      require => Exec["unpack_flume"];
  }

}
