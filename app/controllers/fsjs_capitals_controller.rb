class FsjsCapitalsController < ApplicationController
  before_action :set_fsjs_capital, only: [:show, :edit, :update, :destroy]

  # GET /fsjs_capitals
  def index
    @fsjs_capitals = FsjsCapital.all.order(yyyy: "DESC")
  end

  # GET /fsjs_capitals/1
  def show
  end

  # GET /fsjs_capitals/new
  def new
    @fsjs_capital = FsjsCapital.new
  end

  # GET /fsjs_capitals/1/edit
  def edit
  end

  # POST /fsjs_capitals
  def create
    @fsjs_capital = FsjsCapital.new(fsjs_capital_params)

    respond_to do |format|
      if @fsjs_capital.save
        format.html { redirect_to fsjs_capitals_path, notice: '登録しました。' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /fsjs_capitals/1
  def update
    respond_to do |format|
      if @fsjs_capital.update(fsjs_capital_params)
        format.html { redirect_to fsjs_capitals_path, notice: '更新しました。' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /fsjs_capitals/1
  def destroy
    @fsjs_capital.destroy
    respond_to do |format|
      format.html { redirect_to fsjs_capitals_url, alert: '削除しました。' }
    end
    
    # 必要であれば、該当年度の仕訳帳も削除して下さい。
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fsjs_capital
      @fsjs_capital = FsjsCapital.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fsjs_capital_params
      params.require(:fsjs_capital).permit(:yyyy, :m1, :m2, :m3, :m4)
    end
end
