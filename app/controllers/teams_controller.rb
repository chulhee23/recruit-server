class TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :team_params, only: %i[create update]
  before_action :load_object, only: %i[show edit update destroy change]
  
  def index
    @teams = Team.all
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.create!(team_params)
    TeamUser.create!(team: @team, user: current_user, role: :captain)
    current_user.update_attributes(team: @team)
    redirect_to team_path(@team)
  end

  def show
    @apply_team_user = TeamUser.where(user: current_user, team: @team, role: :apply).first
    @team_users = TeamUser.where(team: @team).all.order(role: :desc)
    @current_team_user = TeamUser.where(user: current_user, team: @team, role: TeamUser::TEAM_MEMBERS).first
    @question_sheets = QuestionSheet.where(team: @team).all    
  end

  def edit

  end

  def update
    @team.update_attributes!(team_params)
    redirect_to team_path(@team)
  end

  def destroy
    @team.destroy
    redirect_to teams_path, notice: "팀을 삭제했습니다."
  end

  def change
    current_user.update_attributes(team: @team)
    redirect_to team_path(@team), notice: "#{@team.name} 팀으로 바뀌었습니다."
  end
  
  private
  def load_object
    @team = Team.find(params[:id])
  end

  def team_params
    params.fetch(:team,{}).permit(:name, :description)
  end

end
