class testguide ( $world ) {
  $path = 'some/useless/directory'
  $directories = sequence_string($path,'/','/tmp/')
  file { $directories:
    ensure => directory,
  }

  file { "/tmp/${path}/hello.txt":
    ensure  => file,
    content => template('testguide/hello.erb')
  }
}
