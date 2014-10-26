class AdminController < ApplicationController
  before_action :set_sizes, only: [:index, :select, :shown, :notice]
  before_action :set_mode, only: [:index, :select, :shown, :notice, :entrytask, :maintask]
  before_action :set_locale
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
    setting = Setting.first
    case params[:commit]
      when 'save'
        setting.update(setting_params[:setting])
      when 'default'
        setting.delete
        setting = Setting.create
      else
    end
    render json: {mode: setting.mode, sizes: set_sizes}
  end

  def togglefeed
    feed = Feed.find(params[:feed])
    feed.update(feed_params)
    render json: {use: feed.use, sizes: set_sizes}
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
    render json: { table: render_to_string(partial: 'entrytable', locals: {action_name: params[:action_name]}), sizes: set_sizes }
  end

  def maintask
    case params[:commit]
      when 'fetchall'
        Feed.fetch_all @mode
      when 'cleanup'
        Entry.clean_up @mode
      when 'revertall'
        Feed.revert_all
      else
    end
    render json: { sizes: set_sizes }
  end

  def checkentry
    entry = Entry.find(params[:entry_id])
    case params[:commit]
      when 'show'
        entry.update(checked: true)
        done = true
      when 'delete'
        entry.delete
        done = false
      else
        done = 0
    end
    render json: {done: done, sizes: set_sizes}
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def set_mode
    @mode = Setting.first.mode
  end

  def set_sizes
    @sizes = {unchecked: Entry.unchecked.size, shown: Entry.shown.size}
  end

  def setting_params
    params.permit(setting: [:mode, :style, :expiration, :frequency, :autocleanup])
  end

  def feed_params
    params.permit(:use)
  end

end
