class LabsController < ApplicationController
  attr_accessor :labs
  def index
    self.labs = Lab.all
  end
end
