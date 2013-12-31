# == Class: jmeter
#
# This class installs the latest stable version of JMeter.
#
# === Examples
#
#   class { 'jmeter': }
#
class jmeter() {
  $rm_extdir = "rm -rf JMeterPlugins-ExtrasLibs/lib/ext/"
  $mv_extlibs = "mv JMeterPlugins-ExtrasLibs/lib/ext/* /usr/share/jmeter/lib/ext/"
  $install_standard = 'unzip -q -d JMeterPlugins-Standard JMeterPlugins-Standard-1.1.2.zip && mv JMeterPlugins-Standard/lib/ext/* /usr/share/jmeter/lib/ext'
  $install_extras   = "unzip -q -d JMeterPlugins-ExtrasLibs JMeterPlugins-ExtrasLibs-1.1.2.zip && $mv_extlibs && $rm_extdir &&  mv JMeterPlugins-ExtrasLibs/lib/* /usr/share/jmeter/lib/"

  package { 'openjdk-7-jre-headless':
    ensure => present,
  }

  package { 'unzip':
    ensure => present,
  }

  package { 'wget':
    ensure => present,
  }

  exec { 'download-jmeter':
    command => 'wget -P /root http://www.dsgnwrld.com/am/jmeter/binaries/apache-jmeter-2.10.tgz',
    path    => ['/bin', '/usr/bin', '/usr/local/bin'],
    creates => '/root/apache-jmeter-2.10.tgz',
    require => Package['wget'],
  }

  exec { 'install-jmeter':
    command => 'tar xzf /root/apache-jmeter-2.10.tgz && mv apache-jmeter-2.10 jmeter',
    path    => ['/bin', '/usr/bin', '/usr/local/bin'],
    cwd     => '/usr/share',
    creates => '/usr/share/jmeter',
    require => Exec['download-jmeter'],
  }

  exec { 'download-standard-jmeter-plugins':
    command => 'wget -P /root http://jmeter-plugins.org/downloads/file/JMeterPlugins-Standard-1.1.2.zip',
    path    => ['/bin', '/usr/bin', '/usr/local/bin'],
    creates => '/root/JMeterPlugins-Standard-1.1.2.zip',
    require => Package['wget'],
  }
  exec { 'download-extra-jmeter-plugins':
    command => 'wget -P /root http://jmeter-plugins.org/downloads/file/JMeterPlugins-ExtrasLibs-1.1.2.zip',
    path    => ['/bin', '/usr/bin', '/usr/local/bin'],
    creates => '/root/JMeterPlugins-ExtrasLibs-1.1.2.zip',
    require => Package['wget'],
  }


  exec { 'install-jmeter-plugins':
    command => "$install_standard && $install_extras",
    path    => ['/bin', '/usr/bin', '/usr/local/bin'],
    cwd     => '/root',
    creates => '/usr/share/jmeter/lib/ext/JMeterPlugins-Standard.jar',
    require => [Package['unzip'], Exec['install-jmeter'], Exec['download-standard-jmeter-plugins']],
  }

}
