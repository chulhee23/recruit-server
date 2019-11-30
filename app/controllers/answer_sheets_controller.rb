class AnswerSheetsController < ApplicationController
  before_action :set_question_sheet
  before_action :set_answer_sheet, except: [:new, :create]
  before_action :authenticate_user!
  def new
    @team = Team.find(@question_sheet.team_id)
    @answer_sheet = @question_sheet.answer_sheets.build
    @question_sheet.questions.each do |question|
      @answer_sheet.answers.build(question: question, answerable: question.questionable)
    end
  end

  def create
    byebug
    answer_sheet = @question_sheet.answer_sheets.create(set_params.merge({user: current_user}))
    redirect_to [@question_sheet, answer_sheet]
  end

  def show
    # 팀의 소속 운영진이 아니라면 자신의 answer sheet만 볼 수 있어야함
    @team = Team.find(@question_sheet.team_id)
    team_user = TeamUser.where(team: @team, user: current_user)

    redirect_to root_path, alert: "권한이 없습니다." unless current_user.manager?(@team) or @answer_sheet.user_id == current_user.id
  end

  def edit
    @team = Team.find(@question_sheet.team_id)
    @answer_sheet = AnswerSheet.find(params[:id])
  end

  def update
  end


  private
  def set_question_sheet
    @question_sheet = QuestionSheet.find(params[:question_sheet_id])
  end

  def set_answer_sheet
    @answer_sheet = AnswerSheet.find(params[:id])
  end

  def set_params
    params.fetch(:answer_sheet,{}).permit(answers_attributes: [:question_id, :answerable_type, answerable_attributes: [:answer]])
  end
end
