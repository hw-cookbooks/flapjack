{
  "id" => "email",
  "enabled" => "yes",
  "queue" => "email_notifications",
  "logger" => {
    "level" => "INFO"
  },
  "smtp_config" => {
    "host" => "localhost",
    "port" => 25,
    "domain" => "localhost.localdomain",
    "starttls" => false,
    "from" => "flapjack@localhost.localdomain"
  }
}
