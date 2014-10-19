class AdminController < ApplicationController

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
    feed.update_use(params[:commit]=='enable' ? true : false, false)
    render nothing: true
  end

  def checkentry
    entry = Entry.find(params[:entry_id])
    case params[:commit]
      when 'show'
        entry.checked = true
        entry.save
        render json: { commit: params[:commit], show: true }
      when 'delete'
        entry.delete
        render json: { commit: params[:commit], show: false }
      else
    end
  end

  def setting
    setting = Setting.first
    setting.update_mode(params[:commit]=='auto' ? true : false)
    render nothing: true
  end

end
