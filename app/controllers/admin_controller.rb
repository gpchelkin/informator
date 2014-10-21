class AdminController < ApplicationController

  layout 'admin'

  def index
      @feeds = Feed.all
      @setting = Setting.first
  end

  def select
    setting = Setting.first
    @mode = setting.mode
    if request.post?
      entrytask params[:commit], @mode
      @entries = Entry.unchecked.desc_ord
      render partial: 'entrytable'
    end
    @entries = Entry.unchecked.desc_ord
  end

  def shown
    setting = Setting.first
    @mode = setting.mode
    if request.post?
      entrytask params[:commit], @mode
      @entries = Entry.shown.desc_ord
      render partial: 'entrytable'
    end
    @entries = Entry.shown.desc_ord
  end

  def entrytask(job, mode)
    case job
      when 'fetchall'
        Feed.fetch_all mode
      when 'cleanup'
        Entry.clean_up mode
      when 'showall'
        Entry.show_all
      when 'deleteallselect'
        Entry.clean_all false
      when 'deleteallshown'
        Entry.clean_all true
      when 'revertall'
        Feed.revert_all
      else
    end
  end

  def notice
  end

  def togglefeed
    feed = Feed.find(params[:feed_id])
    case params[:commit]
      when 'enable'
        feed.update_use(true, false)
      when 'disable'
        feed.update_use(false, false)
      else
    end
    render json: {done: params[:commit]}
  end

  def checkentry
    entry = Entry.find(params[:entry_id])
    case params[:commit]
      when 'show'
        entry.checked = true
        entry.save
      when 'delete'
        entry.delete
      else
    end
    render json: {done: params[:commit]}
  end

  def setting
    setting = Setting.first
    case params[:commit]
      when 'auto'
        setting.update_mode(true)
      when 'manual'
        setting.update_mode(false)
      when 'save'
        setting.update(setting_params)
      else
    end
    render nothing: true
  end

  private
  def setting_params
    params.permit(:frequency,:expiration)
  end

end
