class Api::BooksController < Api::BaseController

  before_action :set_book, only: [:show, :borrow, :repay, :actual_income]

  def index
    collection = Book.all
    if params[:name].present?
      collection = collection.where("name ILIKE ?", "%#{params[:name].downcase}%")
    end
    @books = collection.page(params[:page]).per(20)
  end

  def show
  end

  def borrow
    @rental_record = @book.rental_records.new(rental_record_params)
    @rental_record.price = @book.price
    @rental_record.kind  = "borrow"
    unless @rental_record.valid?
      render json: { errors: formate_response_errors(@rental_record.errors)}, status: 422
      return
    end
    begin
      @rental_record.run_borrow
      render json: { message: "Borrow book success"}, status: 200
    rescue => exception
      render json: { errors: exception.message}, status: 422
      return
    end
  end

  def repay
    @rental_record = @book.rental_records.new(rental_record_params)
    @rental_record.kind = "repay"
    @rental_record.filling_repay_attributes
    unless @rental_record.valid?
      render json: { errors: formate_response_errors(@rental_record.errors)}, status: 422
      return
    end
    begin
      @rental_record.run_repay
      render json: { message: "Repay book success"}, status: 200
    rescue => exception
      render json: { errors: exception.message}, status: 422
      return
    end
  end

  def actual_income
    collection = @book.rental_records.repay_records
    if params[:begin_date].present?
      if (begin_date = Date.parse(params[:begin_date]) rescue nil).blank?
        render json: {error: "Begin date is invalid"}, status: 422
        return
      end
      collection = collection.where("created_at >= ?", begin_date.beginning_of_day)
    end
    if params[:end_date].present?
      if (end_date = Date.parse(params[:end_date]) rescue nil).blank?
        render json: {error: "End date is invalid"}, status: 422
        return
      end
      collection = collection.where("created_at <= ?", end_date.end_of_day)
    end
    render json: {actual_income: collection.sum(:price).to_f}
  end

  private
    def set_book
      @book = Book.find(params[:id])
    end

    def rental_record_params
      params.permit(:user_id)
    end

end
