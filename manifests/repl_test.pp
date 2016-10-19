class repl::repl_test(
  $var1 = 'value1',
  $var2 = ['value1', 'value2', 'value3']
)
{
  # dummy resources so we can show list of resources
  file{'/tmp/test.txt': ensure => present, mode => '0755'}
  service{'httpd': ensure => running}

  # how to find values with an empheral scope
  $var2.each | String $item | {
    file{"/tmp/${item}": ensure => present}
    start_repl()
  }

  if $var1 == 'value1' {
    start_repl()
  }
}
