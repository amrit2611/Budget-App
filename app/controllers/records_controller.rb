class RecordsController < ApplicationController
  before_action :set_record, only: %i[show edit update destroy]
  before_action :authenticate_user!
  load_and_authorize_resource :category

  def index
    @records = Rails.cache.fetch("all_records", expires_in: 1.hour) do
      Record.all
    end
  end

  def show
    # @category = Category.find(params[:id])
    # @records = @category.records.order(created_at: :desc)
    @category = Category.find(params[:category_id])
    @record = @category.records.find(params[:id])
  end

  # GET /records/new
  def new
    @record = Record.new
    @category = Category.find(params[:category_id])
  end

  # GET /records/1/edit
  def edit; end

  def create
    @category = Category.find(params[:category_id])
    @record = Record.new(record_params)
    @record.user = current_user

    respond_to do |format|
      if @record.save
        category_record = @category.category_records.new(record: @record)

        if category_record.save
          Rails.logger.info("Transaction was successfully created.")
          format.html { redirect_to category_url(@category), notice: 'Transaction was successfully created.' }
        else
          Rails.logger.error("Failed to save category_record: #{category_record.errors.full_messages}")
          format.html { render :new, status: :unprocessable_entity }
        end
      else
        Rails.logger.error("Failed to save record: #{record.errors.full_messages}")
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /records/1 or /records/1.json
  def update
    respond_to do |format|
      if @record.update(record_params)
        format.html { redirect_to category_record_url(@category, @record), notice: 'Record was successfully updated.' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /records/1 or /records/1.json
  def destroy
    @record = set_record
    # @record.delete
    @record.destroy

    respond_to do |format|
      format.html { redirect_to category_url(@category), notice: 'Record was successfully destroyed.' }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_record
    @record = Record.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def record_params
    params.require(:record).permit(:name, :amount)
  end
end
