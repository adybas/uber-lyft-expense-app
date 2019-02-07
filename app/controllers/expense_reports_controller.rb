class ExpenseReportsController < ApplicationController
  before_action :login_required

  def by_year
    if params[:year] == ""
      redirect_to user_expense_reports_path(current_user)
    else
      year = params[:year]
      @user = current_user
      @reports = @user.expense_reports
      @expense_reports = @user.expense_reports.by_year(year)
      render json: @expense_reports, status: 201
      # render :index
    end
  end

  # def current_report
  #   Need to add logic so that this method only keeps track of a specific users current expense report
  #   @expense_report = ExpenseReport.current_expense_report
  #   @expenses = Expense.all.select {|e| e.expense_report_id == @expense_report.id}
  # end

  def show
    @expense_report = ExpenseReport.find_by(id: params[:id])
    @expenses = Expense.all.select {|e| e.expense_report_id == @expense_report.id}
  end

  def index
    @user = current_user
    @expense_reports = @user.expense_reports
    @reports = @user.expense_reports
  end

  def new
    @user = current_user
    @expense_report = ExpenseReport.new(user_id: params[:user_id])
  end

  def create
    @expense_report = ExpenseReport.new(expense_report_params)

    if @expense_report.save
      flash[:success] = "Successfully created new expense report"
      redirect_to expense_report_path(@expense_report)
    else
      @user = current_user
      render :new
    end

  end

  def edit
    @user = current_user
    @expense_report = ExpenseReport.find_by(id: params[:id])
  end

  def update
    @user = current_user
    @expense_report = ExpenseReport.find_by(id: params[:id])

    if @expense_report.update(expense_report_params)
      flash[:success] = "Successfully updated expense report"
      redirect_to expense_report_path(@expense_report)
    else
      flash[:alert] = "Something went wrong updating this report. Try again."
      @user = current_user
      @expense_report = ExpenseReport.find_by(id: params[:id])
      render :edit
    end

  end

  def destroy
    @expense_report = ExpenseReport.find_by(id: params[:id])
    @expense_report.destroy
    flash[:success] = "Successfully deleted expense report"
    redirect_to user_expense_reports_path(current_user.expense_reports)
  end

  private

  def expense_report_params
    params.require(:expense_report).permit(:month, :year, :user_id)
  end
end
