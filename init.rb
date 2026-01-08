require 'redmine'

Redmine::Plugin.register :redmine_extended_api do
  name 'Extended API'
  author 'Leander Kretschmer'
  description 'Erweitert die Redmine API um E-Mail-Verwaltung, Kontakt-Zuweisung und Rückdatierung von Tickets/Kommentaren'
  version '0.0.5'
  url 'https://github.com/leanderkretschmer/redmine-extended-api'
  author_url 'https://github.com/leanderkretschmer'
  requires_redmine version_or_higher: '6.0.0'
end
