class InformController < ApplicationController
  def index
  end

  def admin
    FeedsFileSaveJob.perform_later
  end
end
