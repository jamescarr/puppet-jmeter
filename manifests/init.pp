# == Class: jmeter
#
# This class installs the latest stable version of JMeter.
#
# === Examples
#
#   class { 'jmeter': }
#
class jmeter() {
  package { 'openjdk-7-jre-headless':
    ensure => present,
  }

  package { 'unzip':
    ensure => present,
  }

  exec { 'download-jmeter':
    command => 'wget -P /root http://mirror.nexcess.net/apache//jmeter/binaries/apache-jmeter-2.10.tgz',
    creates => '/root/apache-jmeter-2.10.tgz'
  }

  exec { 'install-jmeter':
    command => 'tar xzf /root/apache-jmeter-2.10.tgz && mv apache-jmeter-2.10 jmeter',
    cwd     => '/usr/share',
    creates => '/usr/share/jmeter',
    require => Exec['download-jmeter'],
  }

  exec { 'download-standard-jmeter-plugins':
    command => 'wget -P /root http://jmeter-plugins.org/downloads/file/JMeterPlugins-Standard-1.1.2.zip',
    creates => '/root/JMeterPlugins-Standard-1.1.2.zip'
  }
  exec { 'download-extra-jmeter-plugins':
    command => 'wget -P /root http://jmeter-plugins.org/downloads/file/JMeterPlugins-ExtrasLibs-1.1.2.zip',
    creates => '/root/JMeterPlugins-ExtrasLibs-1.1.2.zip'
  }

  exec { 'install-jmeter-plugins':
    command => ['unzip -q -d JMeterPlugins-Standard JMeterPlugins-Standard-1.1.2.zip && mv JMeterPlugins-Standard/lib/ext/* /usr/share/jmeter/lib/ext'],
    cwd     => '/root',
    creates => '/usr/share/jmeter/lib/ext/JMeterPlugins-Standard.jar',
    require => [Package['unzip'], Exec['install-jmeter'], Exec['download-standard-jmeter-plugins']],
  }

}
