class LabsController < ApplicationController
  attr_accessor :labs, :lab
  before_action :set_lab, only: %i[show update destroy]

  def index
    self.labs = Lab.all.order(:id)
  end

  def show
    render json: self.lab
  end

  def create
    error = check_date_of_issue(Lab.count + 2, Date.parse(lab_params[:date_of_issue]))

    unless error.nil?
      render json: { success: false, errors: error }, status: :unprocessable_entity
      return
    end

    self.lab = Lab.new(lab_params)
    if self.lab.save
      render json: { success: true }, status: :ok
    else
      render json: { errors: self.lab.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    error = check_date_of_issue(params[:id].to_i + 1, Date.parse(lab_params[:date_of_issue]))

    unless error.nil?
      render json: { success: false, errors: error }, status: :unprocessable_entity
      return
    end

    if no_data_changes?
      render json: { success: false, errors: "Данные не были изменены" }, status: :unprocessable_entity
      return
    end

    if self.lab.update(lab_params)
      render json: { success: true }
    else
      render json: { success: false, errors: self.lab.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    last_lab = Lab.last
    if last_lab.id != self.lab.id
      render json: { success: false, errors: "Эта лабораторная не последняя" }, status: :unprocessable_entity
      return
    end

    if self.lab.destroy
      render json: { success: true, message: "Лабораторная работа успешно удалена" }, status: :ok
    else
      render json: { success: false, errors: "Не удалось удалить лабораторную работу" }, status: :unprocessable_entity
    end
  end

  private

  # set lab
  def set_lab
    self.lab = Lab.limit(1).offset(params[:id].to_i).first
  end

  # lab params
  def lab_params
    params.require(:lab).permit(:name, :topics, :tasks, :date_of_issue)
  end

  # date of issue validation
  def check_date_of_issue(num, date_of_issue)
    lab_count = Lab.count
    return nil if lab_count.zero?

    prev_lab = Lab.offset(num - 2).first if num > 1
    next_lab = Lab.offset(num).first if num < lab_count

    if prev_lab && prev_lab.date_of_issue > date_of_issue
      return "Вы не можете выдать эту лабораторную работу раньше предыдущей. Срок выдачи ЛР №#{num - 1} - #{prev_lab.date_of_issue.strftime('%d.%m.%Y')}"
    end

    if next_lab && next_lab.date_of_issue < date_of_issue
      return "Вы не можете выдать эту лабораторную работу позже следующей. Срок выдачи ЛР №#{num + 1} - #{next_lab.date_of_issue.strftime('%d.%m.%Y')}"
    end

    nil
  end

  # check no data changes
  def no_data_changes?
    new_data = lab_params

    new_data[:name] == self.lab.name && new_data[:topics] == self.lab.topics &&
      new_data[:tasks] == self.lab.tasks && Date.parse(new_data[:date_of_issue]) == self.lab.date_of_issue
  end
end
