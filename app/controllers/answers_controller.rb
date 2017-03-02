# frozen_string_literal: true
class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :set_question, only: [:create]

  def new
    @answer = Answer.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      redirect_to @question, notice: t('activerecord.controllers.answers.create')
    else
      flash[:alert] = t('activerecord.controllers.answers.error_create')
      render 'questions/show'
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    flash[:alert] = t('activerecord.controllers.answers.no_delete')
    @question = @answer.question
    if current_user.author?(@answer)
      @answer.destroy
      flash[:notice] = t('activerecord.controllers.answers.delete')
      redirect_to @answer.question
    else
      render 'questions/show'
    end
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, :question_id)
  end
end
