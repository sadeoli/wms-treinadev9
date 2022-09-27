class ProductModelsController < ApplicationController
    before_action :set_product_model, only: [:show, :edit, :update] 

    def index
        @product_models = ProductModel.all
    end

    def new
        @product_models = ProductModel.new
        @suppliers = Supplier.all
    end

    def create
        @product_model = ProductModel.new(product_model_params)
        if @product_model.save
            redirect_to @product_model, notice: 'Modelo de produto cadastrado com sucesso.'
        else
            flash[:notice] = 'Não foi possível cadastrar o modelo de produto.'
            render 'create'
        end
    end

    def show
    end


    private

    def set_product_model 
        @product_model = ProductModel.find(params[:id])
    end

    def product_model_params
        params.require(:product_model).permit(:name, :height, :width, :depth, :weight, :sku, :supplier_id)
    end

end
