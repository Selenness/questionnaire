class UserVotesController < ApplicationController
  def create
    @votable = params[:user_vote][:votable_type].constantize.find(params[:user_vote][:votable_id])
    @user_vote = current_user.user_votes.create(user_vote_params) unless current_user.author_of?(@votable) || @votable.voted_by?(current_user)
    render json: @votable.rate
  end

  def destroy
    @user_vote = UserVote.find(params[:id])
    @user_vote.destroy if current_user.author_of?(@user_vote)
    render json: @user_vote.votable.rate
  end

  private

  def user_vote_params
    params
        .require(:user_vote)
        .permit(:votable_id, :votable_type)
        .merge(pro: params[:user_vote][:pro] == 'true' ? 1 : -1)
  end
end
