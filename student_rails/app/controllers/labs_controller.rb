class LabsController < BaseController
  before_action :set_entity, only: %i[destroy update show]

  def index
    self.entities = Lab.all.order(:id)
  end

  def create
    error = check_date_of_issue(Lab.count + 2, Date.parse(entity_params[:date_of_issue]))

    unless error.nil?
      render_error(error)
      return
    end

    self.entity = Lab.new(entity_params)
    super
  end

  def update
    error = check_date_of_issue(params[:id].to_i + 1, Date.parse(entity_params[:date_of_issue]))

    unless error.nil?
      render_error(error)
      return
    end

    super
  end

  def destroy
    last_lab = Lab.last
    if last_lab.id != self.entity.id
      render_error("Эта лабораторная не последняя")
      return
    end

    if self.entity.destroy
      render json: { success: true, message: "Лабораторная работа успешно удалена" }, status: :ok
    else
      render_error("Не удалось удалить лабораторную работу")
    end
  end

  private

  # set entity
  def set_entity
    self.entity = Lab.limit(1).offset(params[:id].to_i).first
  end

  # entity params
  def entity_params
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
    new_data = entity_params

    new_data[:name] == self.entity.name && new_data[:topics] == self.entity.topics &&
      new_data[:tasks] == self.entity.tasks && Date.parse(new_data[:date_of_issue]) == self.entity.date_of_issue
  end
end
