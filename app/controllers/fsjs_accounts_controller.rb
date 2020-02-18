class FsjsAccountsController < ApplicationController
  before_action :set_fsjs_account, only: [:show, :edit, :update, :destroy]
  
  before_action :fsjs_get_account_types_combobox
  helper_method :fsjs_get_account_types_from_id
    
  # GET /fsjs_accounts
  def index
    @fsjs_accounts = FsjsAccount.all.order(sort_list: "ASC")
  end

  # GET /fsjs_accounts/1
  def show
  end

  # GET /fsjs_accounts/new
  def new
    @fsjs_account = FsjsAccount.new
  end

  # GET /fsjs_accounts/1/edit
  def edit
  end

  # POST /fsjs_accounts
  def create
    @fsjs_account = FsjsAccount.new(fsjs_account_params)

    respond_to do |format|
      if @fsjs_account.save
        format.html { redirect_to fsjs_accounts_path, notice: '登録しました。' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /fsjs_accounts/1
  def update
    respond_to do |format|
      if @fsjs_account.update(fsjs_account_params)
        format.html { redirect_to fsjs_accounts_path, notice: '更新しました。' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /fsjs_accounts/1
  def destroy
    @fsjs_account.destroy
    respond_to do |format|
      format.html { redirect_to fsjs_accounts_url, alert: '削除しました。' }
    end
  end

  private
    # コンボボックス用 - 種類
    def fsjs_get_account_types_combobox()
      @fsjs_account_types_list = []
      @fsjs_account_types_list.push(['借方',1])
      @fsjs_account_types_list.push(['貸方',2])
      @fsjs_account_types_list.push(['借方 + 貸方',3])
    end  

    # idから種類を取得する 
    def fsjs_get_account_types_from_id(id)
     @fsjs_account_types_list.each_with_index do |obj,i|
       if(obj[1] == id)
         return obj[0]
       end  
     end
     return "";
    end  
        
    # Use callbacks to share common setup or constraints between actions.
    def set_fsjs_account
      @fsjs_account = FsjsAccount.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fsjs_account_params
      params.require(:fsjs_account).permit(:name, :types, :expense_flg, :sort_list, :sort_expense)
    end
end
