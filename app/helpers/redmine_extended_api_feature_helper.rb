module RedmineExtendedApiFeatureHelper
  def self.feature_enabled?(env_var_name)
    value = ENV[env_var_name.to_s]
    value == 'true' || value == true
  end

  def self.user_mails_enabled?
    feature_enabled?('REDMINE_EXTENDED_API_FEATURE_USER_MAILS_ENABLED')
  end

  def self.assigned_contacts_enabled?
    feature_enabled?('REDMINE_EXTENDED_API_FEATURE_ASSIGNED_CONTACTS_ENABLED')
  end

  def self.backdating_enabled?
    feature_enabled?('REDMINE_EXTENDED_API_FEATURE_BACKDATING_ENABLED')
  end
end

