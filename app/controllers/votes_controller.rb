# frozen_string_literal: true
class VotesController < ApplicationController
  include Contexted
  include Serialized

  before_action :authenticate_user!
  before_action :set_context!, only: [:create]

  def create
    if !current_user.author?(@context) && @context.vote_user(current_user).nil?
      @vote = @context.send("vote_#{vote_params[:rating]}", current_user)
      if @vote.persisted?
        render json: VotePresenter.new(@vote).as(:create)
      else
        render_error(:unprocessable_entity, 'Error save', 'Not the correct vote data!')
      end
    else
      render_error(:forbidden, 'Error save', 'You can not vote')
    end
  end

  def destroy
    vote = Vote.find(params[:id])
    if current_user.author?(vote)
      vote.destroy
      render json: VotePresenter.new(vote).as(:destroy)
    else
      render_error(:forbidden, 'Error remove', 'You can not remove an vote!')
    end
  end

  private

  def vote_params
    { rating: params[:rating] == 'up' ? :up : :down }
  end
end
