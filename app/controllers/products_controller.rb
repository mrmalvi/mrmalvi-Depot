class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :destroy]

  def index
    @products = Product.all.order(:title)
  end

  def show
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product,
          notice: 'Product was successfully created.' }
        format.json { render :show, status: :created,
          location: @product }

          @products = Product.all.order(:title)
          ActionCable.server.broadcast 'products',
            html: render_to_string('store/index', layout: false)
      else
        format.html { render :new }
        format.json { render json: @product.errors,
          status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      redirect_to :products
    end
  end

  def destroy
    if @product.destroy
      redirect_to :products
    end
  end

  def who_bought
    @product = Product.find(params[:id])
    @latest_order = @product.orders.order(:updated_at).last
    if stale?(@latest_order)
      respond_to do |format|
        format.atom
      end
    end
  end

  private
    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:title, :description, :image_url, :price)
    end
end
