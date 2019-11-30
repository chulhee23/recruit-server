class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :load_sidebar_hash

  #추가
  def configure_permitted_parameters
    added_attrs = %i{name image phone}
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
  
  
  private
  
  # sidebar 에 필요한 hash load
  def load_sidebar_hash
    if current_user
      teams = TeamUser.where(user: current_user, role: TeamUser::TEAM_MEMBERS).pluck(:team_id)
      apply_teams = TeamUser.where(user: current_user).apply.pluck(:team_id)
      @my_teams_hash = {}
      @my_apply_teams_hash = {}
      
      teams.each do |team_id|
        team = Team.find(team_id)
        @my_teams_hash[team.name] = team
      end
      
      apply_teams.each do |team_id|
        team = Team.find(team_id)
        @my_apply_teams_hash[team.name] = team
      end
      @teams_hash = {
        '나의 소속 팀': @my_teams_hash,
        '나의 지원 팀': @my_apply_teams_hash,
        '모든 팀 보기': teams_path,
        '팀 생성하기': new_team_path
      }
    end
  end
  
end
