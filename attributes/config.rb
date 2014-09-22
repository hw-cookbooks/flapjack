default["flapjack"]["environment"] = "production"

default["flapjack"]["config"]["pid_file"] = "/var/run/flapjack/flapjack.pid"
default["flapjack"]["config"]["log_file"] = "/var/log/flapjack/flapjack.log"
default["flapjack"]["config"]["daemonize"] = "no"
default["flapjack"]["config"]["logger"]["level"] = "INFO"
default["flapjack"]["config"]["logger"]["syslog_errors"] = "yes"

default["flapjack"]["config"]["redis"]["host"] = "127.0.0.1"
default["flapjack"]["config"]["redis"]["port"] = 6379
default["flapjack"]["config"]["redis"]["db"] = 0

default["flapjack"]["config"]["processor"]["enabled"] = "yes"
default["flapjack"]["config"]["processor"]["queue"] = "events"
default["flapjack"]["config"]["processor"]["notifier_queue"] = "notifications"
default["flapjack"]["config"]["processor"]["archive_events"] = true
default["flapjack"]["config"]["processor"]["events_archive_maxage"] = 10800
default["flapjack"]["config"]["processor"]["new_check_scheduled_maintenance_duration"] = "100 years"
default["flapjack"]["config"]["processor"]["logger"]["level"] = "INFO"
default["flapjack"]["config"]["processor"]["logger"]["syslog_errors"] = "yes"

default["flapjack"]["config"]["notifier"]["enabled"] = "yes"
default["flapjack"]["config"]["notifier"]["queue"] = "notifications"
default["flapjack"]["config"]["notifier"]["email_queue"] = "email_notifications"
default["flapjack"]["config"]["notifier"]["sms_queue"] = "sms_notifications"
default["flapjack"]["config"]["notifier"]["jabber_queue"] = "jabber_notifications"
default["flapjack"]["config"]["notifier"]["pagerduty_queue"] = "pagerduty_notifications"
default["flapjack"]["config"]["notifier"]["notification_log_file"] = "/var/log/flapjack/notification.log"
default["flapjack"]["config"]["notifier"]["default_contact_timezone"] = "UTC"
default["flapjack"]["config"]["notifier"]["logger"]["level"] = "INFO"
default["flapjack"]["config"]["notifier"]["logger"]["syslog_errors"] = "yes"

default["flapjack"]["config"]["gateways"]["web"]["enabled"] = "yes"
default["flapjack"]["config"]["gateways"]["web"]["port"] = 5080
default["flapjack"]["config"]["gateways"]["web"]["timeout"] =  300
default["flapjack"]["config"]["gateways"]["web"]["auto_refresh"] =  120
default["flapjack"]["config"]["gateways"]["web"]["access_log"] = "/var/log/flapjack/web_access.log"
default["flapjack"]["config"]["gateways"]["web"]["api_url"] =  "http://localhost:5081/"
default["flapjack"]["config"]["gateways"]["web"]["logger"]["level"] = "DEBUG"
default["flapjack"]["config"]["gateways"]["web"]["logger"]["syslog_errors"] = "yes"

default["flapjack"]["config"]["gateways"]["jsonapi"]["enabled"] = "yes"
default["flapjack"]["config"]["gateways"]["jsonapi"]["host"] = "127.0.0.1"
default["flapjack"]["config"]["gateways"]["jsonapi"]["port"] = 5081
default["flapjack"]["config"]["gateways"]["jsonapi"]["logger"]["level"] = "INFO"
