class FsjsMainController < ApplicationController
  def index
  
    @capital = FsjsCapital.all.order(yyyy: "DESC")
    
    if params[:yyyy].present?
      
      # ----------------------------------
      # 損益計算書
      # ----------------------------------
      
      # 売上
      sql = "SELECT IFNULL(SUM(money),0) AS money  FROM fsjs_journals WHERE yyyy = ? AND credit_account_id = 12"
      @report_pl_total = FsjsJournal.find_by_sql([sql,params[:yyyy]])[0][:money]
      # 経費   
      sql = "SELECT fsjs_accounts.name,IFNULL(SUM(fsjs_journals.money),0) AS money FROM fsjs_accounts "+
            " LEFT JOIN fsjs_journals ON fsjs_accounts.id = fsjs_journals.debit_account_id AND fsjs_journals.yyyy = ? "+
            " WHERE fsjs_accounts.expense_flg = 1  "+
            " GROUP BY fsjs_accounts.name "+
            " ORDER BY fsjs_accounts.sort_expense ASC "
      @report_pl_keihi = FsjsJournal.find_by_sql([sql,params[:yyyy]])
            
      # ----------------------------------
      #  月別売上(収入)金額及び仕入金額      
      # ----------------------------------
      
      @report_month = []
      12.times do |i|
        sql = "SELECT IFNULL(SUM(money),0) AS money  FROM fsjs_journals WHERE yyyy = ? AND mm = " + (i+1).to_s() +" AND credit_account_id = 12"
        @report_month[i] = FsjsJournal.find_by_sql([sql,params[:yyyy]])[0]
      end
      
      # ----------------------------------
      # 貸借対照表
      # ----------------------------------
      
      # 元入金(期首)
      @report_bs_st = FsjsCapital.where(yyyy: params[:yyyy])[0]
      
      if @report_bs_st.blank?        
        @report_bs_st = {}
        @report_bs_st[:m1] =0
        @report_bs_st[:m2] =0
        @report_bs_st[:m3] =0
        @report_bs_st[:m4] =0        
      end
      
      # 事業主貸(期末)
      sql = "SELECT IFNULL(SUM(money),0) AS money  FROM fsjs_journals WHERE yyyy = ? AND debit_account_id = 1"
      @report_bs_debit = FsjsJournal.find_by_sql([sql,params[:yyyy]])[0][:money]    
      # 事業主借(期末)
      sql = "SELECT IFNULL(SUM(money),0) AS money  FROM fsjs_journals WHERE yyyy = ? AND credit_account_id = 2"
      @report_bs_credit = FsjsJournal.find_by_sql([sql,params[:yyyy]])[0][:money]
      
      # 現金(期末)
      @report_bs_m1 = fsjs_get_account_total(params[:yyyy],:m1,3)
      # その他の預金(期末)
      @report_bs_m2 = fsjs_get_account_total(params[:yyyy],:m2,4)
      # 前払金(期末)
      @report_bs_m3 = fsjs_get_account_total(params[:yyyy],:m3,13)
      # 未払金(期末)
      @report_bs_m4 = fsjs_get_account_total(params[:yyyy],:m4,5)           
    end      
  end
end
