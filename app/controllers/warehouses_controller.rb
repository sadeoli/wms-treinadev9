class WarehousesController < ApplicationController
    def show
        @warehouse = Warehouse.find(params[:id])
    end

    def new
        @warehouse = Warehouse.new

    end

    def create
        w_params = params.require(:warehouse).permit(:name, :description, :code, :adress, :city, :cep, :area, :state)
        @warehouse = Warehouse.new(w_params)

        if @warehouse.save
            redirect_to root_path, notice: 'Galpão cadastrado com sucesso.'
        end

    end

end
