# == Class: jmeter::server
#
# This class configures the server component of JMeter.
#
# === Examples
#
#   class { 'jmeter::server': }
#
class jmeter::server($server_ip = '127.0.0.1') {
  include jmeter

  file { '/etc/init.d/jmeter':
    content => template('jmeter/jmeter-init.erb'),
    owner   => root,
    group   => root,
    mode    => 0755,
  }

  exec { 'jmeter-update-rc':
    command     => 'update-rc.d jmeter defaults',
    subscribe   => File['/etc/init.d/jmeter'],
    refreshonly => true,
    path        => '/usr/sbin',
  }

  service { 'jmeter':
    ensure    => running,
    enable    => true,
    require   => Exec['jmeter-update-rc'],
    subscribe => [File['/etc/init.d/jmeter'], Exec['install-jmeter-plugins']],
  }
}
