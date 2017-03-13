# frozen_string_literal: true
class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy, :update, :mark_best]
  before_action :set_answer, only: [:update, :destroy, :mark_best]
  before_action :set_question, only: [:create]

  def new
    @answer = Answer.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def mark_best
    @answer.mark_best if current_user.author?(@answer.question)
  end

  def update
    @answer.update(answer_params) if current_user.author?(@answer)
  end

  def destroy
    @answer = Answer.find(params[:id])
    @question = @answer.question
    if current_user.author?(@answer)
      @answer.destroy
      flash[:notice] = t('activerecord.controllers.answers.delete')
      redirect_to @answer.question
    else
      flash[:alert] = t('activerecord.controllers.answers.no_delete')
      render 'questions/show'
    end
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, :question_id, attachments_attributes: [:file])
  end
end
