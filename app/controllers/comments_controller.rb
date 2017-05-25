class CommentsController < ApplicationController

  authorize_resource

  after_action :publish_comment

  def create
    @comment = Comment.create(comment_params)
    head :ok
  end


  private

  def comment_params
    params.require(:comment).permit(:text, :commentable_id, :commentable_type)
  end

  def publish_comment
    ActionCable.server.broadcast("comments_for_#{ @comment.commentable_type}_#{@comment.commentable_id }",
                                 ApplicationController.render(
                                     partial: 'comments/comment',
                                     locals: { comment: @comment }
                                 )
    )
  end
end