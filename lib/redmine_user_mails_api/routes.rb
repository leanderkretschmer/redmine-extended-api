# Routes-Klasse für das Plugin
# Diese Klasse wird verwendet, um die Routes korrekt in Redmine zu integrieren

module RedmineUserMailsApi
  class Routes
    def self.mount
      RedmineApp::Application.routes.append do
        match 'users/:user_id/mails(.:format)', :to => 'user_mails#index', :via => [:get], :as => 'user_mails'
        match 'users/:user_id/mails(.:format)', :to => 'user_mails#create', :via => [:post]
        match 'users/:user_id/mails/:id(.:format)', :to => 'user_mails#show', :via => [:get], :as => 'user_mail'
        match 'users/:user_id/mails/:id(.:format)', :to => 'user_mails#update', :via => [:put, :patch]
        match 'users/:user_id/mails/:id(.:format)', :to => 'user_mails#destroy', :via => [:delete]
      end
    end
  end
end

