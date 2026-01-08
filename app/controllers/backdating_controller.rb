class BackdatingController < ApplicationController
  accept_api_auth :backdate_issue, :backdate_journal, :list_journals

  before_action :find_issue
  before_action :find_journal, :only => [:backdate_journal]
  before_action :authorize_global

  # GET /issues/:issue_id/journals_list.json
  # Listet alle Journals (Kommentare) eines Tickets auf
  def list_journals
    journals = @issue.journals.includes(:user).order(:created_on)

    respond_to do |format|
      format.json {
        render :json => {
          :issue_id => @issue.id,
          :journals => journals.map { |j| journal_to_hash(j) }
        }
      }
    end
  end

  # PUT /issues/:issue_id/backdate.json
  # Setzt created_on und/oder updated_on eines Tickets auf ein bestimmtes Datum
  def backdate_issue
    created_on = params[:created_on]
    updated_on = params[:updated_on]

    unless created_on.present? || updated_on.present?
      respond_to do |format|
        format.json {
          render :json => {:error => 'Mindestens created_on oder updated_on muss angegeben werden'}, :status => :bad_request
        }
      end
      return
    end

    update_hash = {}

    if created_on.present?
      parsed_created = parse_datetime(created_on)
      unless parsed_created
        respond_to do |format|
          format.json {
            render :json => {:error => 'Ungültiges Datumsformat für created_on. Verwende ISO 8601 Format (z.B. 2024-01-15T10:30:00Z)'}, :status => :bad_request
          }
        end
        return
      end
      update_hash[:created_on] = parsed_created
    end

    if updated_on.present?
      parsed_updated = parse_datetime(updated_on)
      unless parsed_updated
        respond_to do |format|
          format.json {
            render :json => {:error => 'Ungültiges Datumsformat für updated_on. Verwende ISO 8601 Format (z.B. 2024-01-15T10:30:00Z)'}, :status => :bad_request
          }
        end
        return
      end
      update_hash[:updated_on] = parsed_updated
    end

    begin
      @issue.update_columns(update_hash)
      @issue.reload

      respond_to do |format|
        format.json {
          render :json => {
            :success => true,
            :issue_id => @issue.id,
            :created_on => @issue.created_on,
            :updated_on => @issue.updated_on
          }, :status => :ok
        }
      end
    rescue => e
      Rails.logger.error "Error in BackdatingController#backdate_issue: #{e.message}\n#{e.backtrace.join("\n")}"
      respond_to do |format|
        format.json {
          render :json => {:error => e.message}, :status => :internal_server_error
        }
      end
    end
  end

  # PUT /issues/:issue_id/journals/:journal_id/backdate.json
  # Setzt created_on eines Kommentars auf ein bestimmtes Datum
  def backdate_journal
    created_on = params[:created_on]

    unless created_on.present?
      respond_to do |format|
        format.json {
          render :json => {:error => 'created_on muss angegeben werden'}, :status => :bad_request
        }
      end
      return
    end

    parsed_created = parse_datetime(created_on)
    unless parsed_created
      respond_to do |format|
        format.json {
          render :json => {:error => 'Ungültiges Datumsformat für created_on. Verwende ISO 8601 Format (z.B. 2024-01-15T10:30:00Z)'}, :status => :bad_request
        }
      end
      return
    end

    begin
      @journal.update_columns(:created_on => parsed_created)
      @journal.reload

      respond_to do |format|
        format.json {
          render :json => {
            :success => true,
            :issue_id => @issue.id,
            :journal_id => @journal.id,
            :created_on => @journal.created_on
          }, :status => :ok
        }
      end
    rescue => e
      Rails.logger.error "Error in BackdatingController#backdate_journal: #{e.message}\n#{e.backtrace.join("\n")}"
      respond_to do |format|
        format.json {
          render :json => {:error => e.message}, :status => :internal_server_error
        }
      end
    end
  end

  private

  def find_issue
    @issue = Issue.find(params[:issue_id])
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.json {
        render :json => {:error => 'Ticket nicht gefunden'}, :status => :not_found
      }
    end
  end

  def find_journal
    @journal = @issue.journals.find(params[:journal_id])
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.json {
        render :json => {:error => 'Kommentar nicht gefunden'}, :status => :not_found
      }
    end
  end

  def parse_datetime(value)
    return nil if value.blank?
    
    begin
      # Versuche ISO 8601 Format
      Time.parse(value.to_s)
    rescue ArgumentError
      begin
        # Versuche DateTime.parse als Fallback
        DateTime.parse(value.to_s).to_time
      rescue ArgumentError
        nil
      end
    end
  end

  def journal_to_hash(journal)
    hash = {
      :id => journal.id,
      :notes => journal.notes.to_s,
      :created_on => journal.created_on,
      :private_notes => journal.private_notes
    }

    if journal.user
      hash[:user] = {
        :id => journal.user.id,
        :name => journal.user.name
      }
    end

    hash
  end
end

