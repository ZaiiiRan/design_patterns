class BaseController < ApplicationController
  attr_accessor :entities, :entity
  before_action :set_entity, only: %i[update show]

  def index
    raise NotImplementedError
  end

  def show
    render json: self.entity
  end

  def create
    if self.entity.save
      render json: { success: true }, status: :ok
    else
      render_error(self.entity.errors.full_messages)
    end
  end

  def update
    if no_data_changes?
      render_error("Данные не были изменены")
      return
    end

    if self.entity.update(entity_params)
      render json: { success: true }
    else
      render_error(self.entity.errors)
    end
  end

  protected

  # set entity
  def set_entity
    raise NotImplementedError
  end

  # entity params
  def entity_params
    raise NotImplementedError
  end

  # check no data changes
  def no_data_changes?
    raise NotImplementedError
  end

  # render error
  def render_error(errors, status: :unprocessable_entity)
    render json: { success: false, errors: Array.wrap(errors) }, status: status
  end
end
