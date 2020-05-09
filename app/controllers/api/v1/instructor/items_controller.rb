class Api::V1::Instructor::ItemsController < ApplicationController
    before_action :authorize_access_request!, :set_admin_variables

    VIEW_ROLES = %w[admin instructor].freeze
    EDIT_ROLES = %w[instructor].freeze

    def create
      item = Item.create item_params
      # Attach picture to our item, if available
      attach_main_pic(item) if admin_params[:picture].present?
  
      # Reply with success if the object was saved, or failure if it was not.
      if item.persisted?
        render json: item, status: 200
      else
        render json: item, status: 400
      end
    end
  
    private
  
    def attach_main_pic(item)
      item.picture.attach(admin_params[:picture])
    end
  
    def item_params
      {
        name: admin_params[:name],
        # description: admin_params[:description],
      }
    end
  
    def admin_params
      params.permit(
        :picture
      )
    end
  end