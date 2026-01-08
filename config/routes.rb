Rails.application.routes.draw do
  match 'mail_search(.:format)', :to => 'user_mails#search', :via => [:get], :as => 'search_user_mail'
  
  match 'users/:user_id/mails(.:format)', :to => 'user_mails#index', :via => [:get], :as => 'user_mails'
  match 'users/:user_id/mails(.:format)', :to => 'user_mails#create', :via => [:post]
  match 'users/:user_id/mails/:id(.:format)', :to => 'user_mails#show', :via => [:get], :as => 'user_mail'
  match 'users/:user_id/mails/:id(.:format)', :to => 'user_mails#update', :via => [:put, :patch]
  match 'users/:user_id/mails/:id(.:format)', :to => 'user_mails#destroy', :via => [:delete]
  match 'issues/:issue_id/assigned_contact(.:format)', :to => 'assigned_contacts#show', :via => [:get], :as => 'issue_assigned_contact'
  match 'issues/:issue_id/assigned_contact(.:format)', :to => 'assigned_contacts#update', :via => [:put, :post]
  match 'issues/:issue_id/backdate(.:format)', :to => 'backdating#backdate_issue', :via => [:put], :as => 'backdate_issue'
  match 'issues/:issue_id/journals/:journal_id/backdate(.:format)', :to => 'backdating#backdate_journal', :via => [:put], :as => 'backdate_journal'
end
