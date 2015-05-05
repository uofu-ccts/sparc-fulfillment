class LineItemsController < ApplicationController

  before_action :find_line_item, only: [:edit, :update]

  def new
    @protocol = Protocol.find(params[:protocol_id])
    @line_item = LineItem.new(protocol: @protocol)
  end

  def create
    @line_item = LineItem.new(line_item_params)
    if @line_item.valid?
      @line_item.save
      flash[:success] = t(:flash_messages)[:line_item][:created]
    else
      @errors = @line_item.errors
    end
  end

  def edit
    @protocol = @line_item.protocol
  end

  def update
    @line_item = LineItem.find(params[:id])
    line_item_validation = LineItem.new(line_item_params, protocol_id: @line_item.protocol_id)
    if line_item_validation.valid?
      @line_item.update(line_item_params)
      flash[:success] = t(:flash_messages)[:line_item][:updated]
    else
      @errors = line_item_validation.errors
    end
  end

  private

  def line_item_params
    params.require(:line_item).permit(:protocol_id, :quantity_requested, :quantity_type, :service_id, :started_at)
  end

  def find_line_item
    @line_item = LineItem.where(id: params[:id]).first
  end
end
