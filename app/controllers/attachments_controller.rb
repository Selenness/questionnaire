class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_attachment
  before_action :check_author

  def destroy
    @attachment.destroy
    head :ok
  end

  private

  def get_attachment
    @attachment = Attachment.find(params[:id])
  end

  def check_author
    redirect_to root_path unless current_user.author_of?(@attachment.attachable)
  end
end