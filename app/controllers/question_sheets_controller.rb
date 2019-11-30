class QuestionSheetsController < ApplicationController
  before_action :set_question_sheet, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def index
    @question_sheets = QuestionSheet.all
  end

  def new
    question_sheet = QuestionSheet.create(team: current_user.team)
    redirect_to edit_question_sheet_path(question_sheet)
  end


  def edit
  end

  def position
    Question.update(*position_params)
  end


  def update
    @question_sheet.update_attributes!(question_sheet_params)
  end

  def destroy
    @question_sheet.destroy
    respond_to do |format|
      format.html { redirect_to question_sheets_url, notice: 'Form sheet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_question_sheet
      @question_sheet = QuestionSheet.find(params[:id])
    end

    def question_sheet_params
      start_date = params[:date].split(" - ")[0]
      start_date = Time.strptime(start_date, "%m/%d/%Y %H:%M")
      end_date = params[:date].split(" - ")[1]
      end_date = Time.strptime(end_date, "%m/%d/%Y %H:%M")
      params.require(:question_sheet).permit(:title, :content).merge(start_date: start_date, end_date: end_date)
    end
    
    def position_params
      JSON.parse(params.permit(:position)["position"]).transpose()
    end
end
