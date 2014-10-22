class AdminController < ApplicationController
  layout 'admin'
  before_action :set_sizes, only: [:index, :select, :shown, :notice]
  before_action :set_mode, only: [:select, :shown, :entrytask]
  http_basic_authenticate_with name: "admin", password: "admin"

  def index
    @feeds = Feed.all
    @setting = Setting.first
  end

  def select
    @entries = Entry.unchecked.desc_ord
  end

  def shown
    @entries = Entry.shown.desc_ord
  end

  def notice
    @notices = Notice.all
  end

  def setting
    @setting = Setting.first
    @setting.update(setting_params[:setting])
    render nothing: true
  end

  def togglefeed
    Feed.find(params[:feed]).update(feed_params)
    render json: {done: params[:commit]}
  end

  def entrytask
    case params[:commit]
      when 'fetchall'
        Feed.fetch_all @mode
      when 'cleanup'
        Entry.clean_up @mode
      when 'showall'
        Entry.show_all
      when 'deleteall'
        if params[:action_name]=='select'
          Entry.clean_all false
        elsif params[:action_name]=='shown'
          Entry.clean_all true
        end
      when 'revertall'
        Feed.revert_all
      else
    end
    case params[:action_name]
      when 'shown'
        @entries = Entry.shown.desc_ord
      when 'select'
        @entries = Entry.unchecked.desc_ord
      else
    end
    render partial: 'entrytable', locals: {action_name: params[:action_name]}
  end

  def checkentry
    entry = Entry.find(params[:entry_id])
    case params[:commit]
      when 'show'
        entry.update(checked: true)
      when 'delete'
        entry.delete
      else
    end
    render json: {done: params[:commit]}
  end

  private
  def set_sizes
    @uncheckedsize = Entry.unchecked.size
    @shownsize = Entry.shown.size
  end

  def set_mode
    @mode = Setting.first.mode
  end

  def setting_params
    params.permit(setting: [:mode, :style, :expiration, :frequency, :autocleanup])
  end

  def feed_params
    params.permit(:use)
  end

end
