class stages {
  stage { 'first':
    before  => Stage['main'],
  }

  class { 'facts':
    stage   => 'first',
  }
}
