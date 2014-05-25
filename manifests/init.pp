class testguide ( $world ) {
  file { '/tmp/hello.txt':
    ensure  => file,
    content => "Hello ${world}!\n"
  }
}
