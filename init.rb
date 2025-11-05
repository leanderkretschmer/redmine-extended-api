# Redmine User Mails API Plugin
# Plugin für Redmine 6, das die API um E-Mail-Verwaltung erweitert

require 'redmine'

Redmine::Plugin.register :redmine_mailer_api do
  name 'Redmine User Mails API'
  author 'Leander Kretschmer'
  description 'Erweitert die Redmine API um die Möglichkeit, mehrere E-Mails pro User zu verwalten'
  version '0.0.1'
  url 'https://github.com/leanderkretschmer/redmine-mailer-api'
  author_url 'https://github.com/leanderkretschmer'

  requires_redmine version_or_higher: '6.0.0'
end

# Routes für das Plugin registrieren
Rails.application.config.to_prepare do
  require File.expand_path('../lib/redmine_mailer_api/routes', __FILE__)
  RedmineMailerApi::Routes.mount
end

