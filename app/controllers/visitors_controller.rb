class VisitorsController < ApplicationController

  def new

    @owner = Owner.new
    flash[:notice] = 'Welcome!'
  end

end