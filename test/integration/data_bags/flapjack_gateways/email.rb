{
  'id' => 'email',
  'enabled' => 'yes',
  'queue' => 'email_notifications',
  'logger' => {
    'level' => 'INFO'
  },
  'templates' => {
    'alert.text' => '/etc/flapjack/templates/email.text.erb',
    'alert.html' => '/etc/flapjack/templates/email.html.erb'
  },
  'smtp_config' => {
    'host' => 'localhost',
    'port' => 25,
    'domain' => 'localhost.localdomain',
    'starttls' => false,
    'from' => 'flapjack@localhost.localdomain'
  }
}
