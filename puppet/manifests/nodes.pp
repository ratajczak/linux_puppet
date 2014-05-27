node default {
  crit( "Node only matched \"default\" for which there is no configuration, $::hostname" )
}

node /.*\.dgudev/ {
  class { 'sudo':
    purge               => false,
    config_file_replace => false,
  }

  include dgu_defaults

  # Thinking of modifying this for your own needs?
  # Don't! Create 'vagrant.pp' in the same directory
  # as your Vagrantfile and the vagrant provisioner
  # will use that instead.
  #include beluga::defaults

  include beluga::developer_tools



  class { 'beluga::facts::role':
    stage => pre,
    role => 'dev',
  }
  class { 'beluga::facts::site':
    stage => pre,
    site => 'standards',
  }

  class { "beluga::frontend_traffic_director":
    extra_selectors           => $extra_selectors,
    frontend_domain           => 'dgud7',
    backend_domain            => 'dgud7',
  }

  class {'beluga::apache_frontend_server':
    domain_name               => 'dgud7',
    owner                     => 'co',
    group                     => 'co'
  }

  class {'beluga::caching_server':
    source_dir => "puppet:///modules/dgu_solr/solr",
  }

  class {'beluga::mysql_server':
  }

  class { 'beluga::drush_server': }

  class { 'beluga::mail_server': }
  class { 'jenkins':
    configure_firewall => false,
  }

  class { 'beluga::ruby_frontend':

  }

  #class {'ckan':
  #  virtual_env_dir => '/tmp/ckan',
  #}

  #class { 'beluga::postgresql_server':
  #}

}


node standards {

  include prod_defaults

  include beluga::developer_tools

  class { 'beluga::facts::role':
    stage => pre,
    role => 'prod',
  }
  class { 'beluga::facts::site':
    stage => pre,
    site => 'standards',
  }

  class { "beluga::frontend_traffic_director":
  }

  class {'beluga::apache_frontend_server':
  }

  class {'beluga::mysql_server':
  }

  class { 'beluga::drush_server': }

}


node dataconversion {
include epimorphics_defaults
}

node dataservice {
include epimorphics_defaults
}
