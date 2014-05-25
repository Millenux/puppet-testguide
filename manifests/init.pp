class testguide ( $world ) {
  file { '/tmp/hello.txt':
    ensure  => file,
    content => template('testguide/hello.erb')
  }
}
