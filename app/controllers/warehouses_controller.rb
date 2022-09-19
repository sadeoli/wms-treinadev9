class WarehousesController < ApplicationController
    def show
        @warehouse = Warehouse.find(params[:id])
    end

    def new
        @warehouse = Warehouse.new

    end

    def create
        w_params = params.require(:warehouse).permit(:name, :description, :code, :adress, :city, :cep, :area)
        @warehouse = Warehouse.new(w_params)
        @warehouse.save
        redirect_to root_path

    end

end
