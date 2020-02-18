class FsjsJournalsController < ApplicationController
  before_action :set_fsjs_journal, only: [:show, :edit, :update, :destroy]

  before_action :fsjs_get_account_debits_combobox, :fsjs_get_account_credits_combobox
  helper_method :fsjs_get_account_from_id
  
  # GET /fsjs_journals
  def index
    if params[:yyyy].blank?
      redirect_to root_path
      return
    end
    @q = FsjsJournal.all.where(yyyy: params[:yyyy]).order(mm: "DESC", dd: "DESC",summary: "ASC", debit_account_id: "ASC")
    @fsjs_journals = @q.page(params[:page]).per(50) 
    
    sql = "SELECT id, name,expense_flg FROM fsjs_accounts WHERE types <> 2 ORDER BY sort_list ASC"
    db_data = FsjsAccount.find_by_sql(sql) 
    
    
    # 元入金テーブル
    @capital = FsjsCapital.where(yyyy: params[:yyyy]) 
    
    if @capital.blank?        
      @capital = []
      @capital[0] = {}
      @capital[0][:m1] =0
      @capital[0][:m2] =0
      @capital[0][:m3] =0
      @capital[0][:m4] =0        
    end
      
    # 現金
    @money = fsjs_get_account_total(params[:yyyy],:m1,3)
    # その他の預金
    @deposit = fsjs_get_account_total(params[:yyyy],:m2,4)
    # 前払金
    @advance_payment = fsjs_get_account_total(params[:yyyy],:m3,13)
    # 未払金
    @accounts_payable = fsjs_get_account_total(params[:yyyy],:m4,5)
    # 売上
    sql = "SELECT IFNULL(SUM(money),0) AS money FROM fsjs_journals WHERE yyyy = ? AND credit_account_id = 12"
    @sales = FsjsJournal.find_by_sql([sql,params[:yyyy]])[0][:money] 
          
  end

  # GET /fsjs_journals/1
  def show
  end

  # GET /fsjs_journals/new
  def new
    @fsjs_journal = FsjsJournal.new
    @fsjs_journal.yyyy = params[:yyyy]
  end

  # GET /fsjs_journals/1/edit
  def edit
  end

  # POST /fsjs_journals
  def create
    @fsjs_journal = FsjsJournal.new(fsjs_journal_params)

    respond_to do |format|
      if @fsjs_journal.save
        format.html { redirect_to fsjs_journals_path(yyyy: @fsjs_journal.yyyy), notice: '登録しました。' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /fsjs_journals/1
  def update
    respond_to do |format|
      if @fsjs_journal.update(fsjs_journal_params)
        format.html { redirect_to fsjs_journals_path(yyyy: @fsjs_journal.yyyy), notice: '更新しました。' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /fsjs_journals/1
  def destroy
    @fsjs_journal.destroy
    respond_to do |format|
      format.html { redirect_to fsjs_journals_path(yyyy: @fsjs_journal.yyyy), alert: '削除しました。' }
    end
  end
   
  private
    
    # コンボボックス用 - 借方
    def fsjs_get_account_debits_combobox()
      sql = "SELECT id, name,expense_flg FROM fsjs_accounts WHERE types <> 2 ORDER BY sort_list ASC"
      db_data = FsjsAccount.find_by_sql(sql) 
      
      @fsjs_account_debits_list = []
      db_data.each_with_index  do |obj, i|
        if(obj['expense_flg'])
          @fsjs_account_debits_list.push(["[経費]" +obj['name'],obj['id']])
        else
          @fsjs_account_debits_list.push([obj['name'],obj['id']])
        end  
      end      
    end  
    
    # コンボボックス用 - 貸方
    def fsjs_get_account_credits_combobox()
      sql = "SELECT id, name FROM fsjs_accounts WHERE types <> 1 ORDER BY sort_list ASC"
      db_data = FsjsAccount.find_by_sql(sql) 
      
      @fsjs_account_credits_list = []
      db_data.each_with_index  do |obj, i|
        @fsjs_account_credits_list.push([obj['name'],obj['id']])
      end      
    end      
    
    # idから種類を取得する 
    def fsjs_get_account_from_id(id)    
      db_data = FsjsAccount.find_by_sql(["SELECT name FROM fsjs_accounts WHERE id = ?",id]) 
      db_data[0]['name']    
    end      
      
    # Use callbacks to share common setup or constraints between actions.
    def set_fsjs_journal
      @fsjs_journal = FsjsJournal.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fsjs_journal_params
      params.require(:fsjs_journal).permit(:yyyy, :mm, :dd, :debit_account_id, :credit_account_id, :money, :summary)
    end
end
