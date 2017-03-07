require_dependency "fink/application_controller"

module Fink
  class ReportsController < ApplicationController
    def create
      FinkReport.create(
        url: params[:url],
        kind: params[:kind],
        kind_id: params[:id]
      )

      render nothing: true
    end

  end
end
