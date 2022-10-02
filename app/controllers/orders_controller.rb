class OrdersController < ApplicationController
    before_action :set_order, only: [:show, :edit, :update, :check_user]
    before_action :check_user, only: [:show, :edit, :update]

    def new
        @order = Order.new
        @warehouses = Warehouse.all 
        @suppliers = Supplier.all
    end

    def create
        @order = Order.new(order_params)
        @order.user = current_user
        if @order.save
            redirect_to @order, notice: 'Pedido registrado com sucesso.'
        else
            @warehouses = Warehouse.all
            @suppliers = Supplier.all
            flash.now[:notice] = 'Não foi possível registrar o pedido.'
            render 'new'
        end
    end

    def show
    end

    def search
        @code = params["query"]
        @orders = Order.where("code LIKE ?", "%#{@code}%")
    end

    def index
        @orders = current_user.orders
        
    end

    def edit
        @warehouses = Warehouse.all 
        @suppliers = Supplier.all
    end

    def update
        @order.update(order_params)
        redirect_to @order, notice: 'Pedido atualizado com sucesso.'
    
    end

    private

    def set_order 
        @order = Order.find(params[:id])
    end

    def order_params
        params.require(:order).permit(:warehouse_id, :supplier_id, :estimated_delivery_date, :user)
    end

    def check_user
        if @order.user != current_user
            return redirect_to root_path, notice: 'Você não possui acesso a esse pedido.'
        end
    end
end