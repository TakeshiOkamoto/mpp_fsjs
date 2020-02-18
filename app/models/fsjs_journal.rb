class FsjsJournal < ApplicationRecord
  validates :yyyy,  presence: true
  validates :yyyy, numericality: { greater_than_or_equal_to: 1989, less_than_or_equal_to: 2099 } , unless: Proc.new { |a| a.yyyy.blank? }
  validates :mm,  presence: true
  validates :mm,   numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 12 } , unless: Proc.new { |a| a.mm.blank? } 
  validates :dd,  presence: true
  validates :dd,   numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 31 } , unless: Proc.new { |a| a.dd.blank? } 
  validates :debit_account_id,  presence: true
  validates :credit_account_id,  presence: true
  validates :money,  presence: true, length: { maximum: 10 }
  validates :money,  numericality: { greater_than_or_equal_to: 1 } , unless: Proc.new { |a| a.money.blank? }   
  validates :summary,  presence: true, length: { maximum: 50 }   
  
  # -------------------
  #  メソッド
  # -------------------
  # 対象科目の合計金額を取得する
  def get_account_total(obj,target_id,edit_id)
  
    if (money.blank?)
      return 0
    end
    
    if (!(credit_account_id == target_id ||  debit_account_id == target_id))
      return 0  
    end
       
    # 元入金テーブル
    capital = FsjsCapital.where(yyyy: yyyy) 
    
    # [編集]
    if edit_id.present?
      # 借方
      sql = "SELECT IFNULL(SUM(money),0) AS money  FROM fsjs_journals WHERE yyyy = ? AND debit_account_id = ? AND id <> ?"
      debit = FsjsJournal.find_by_sql([sql,yyyy,target_id,edit_id]) 
      # 貸方
      sql = "SELECT IFNULL(SUM(money),0) AS money  FROM fsjs_journals WHERE yyyy = ? AND credit_account_id = ? AND id <> ?"
      credit = FsjsJournal.find_by_sql([sql,yyyy,target_id,edit_id])            
    # [新規登録]
    else
      # 借方
      sql = "SELECT IFNULL(SUM(money),0) AS money  FROM fsjs_journals WHERE yyyy = ? AND debit_account_id = ?"
      debit = FsjsJournal.find_by_sql([sql,yyyy,target_id]) 
      # 貸方
      sql = "SELECT IFNULL(SUM(money),0) AS money  FROM fsjs_journals WHERE yyyy = ? AND credit_account_id = ?"
      credit = FsjsJournal.find_by_sql([sql,yyyy,target_id])         
    end
             
    # 未払金
    if (target_id == 5) 
          
      # 借方
      if debit_account_id == target_id      
        total = (debit[0][:money] + money) - (capital[0][obj] + credit[0][:money]) 
      # 貸方  
      else
        total = (debit[0][:money]) - (capital[0][obj] + credit[0][:money] + money) 
      end       

    # 現金、その他の預金、前払金
    else
      
      # 借方
      if debit_account_id == target_id
        total = (capital[0][obj] + debit[0][:money] + money) - credit[0][:money]
      # 貸方  
      else
        total = (capital[0][obj] + debit[0][:money]) - credit[0][:money] - money
      end
    end    
            
    total
  end    
    
  # -------------------
  #  カスタムメソッド
  # -------------------
  
  # 同一科目
  validate :same_account_id
  def same_account_id
    if debit_account_id.present?
      if debit_account_id ==  credit_account_id
        errors.add(:debit_account_id, "と科目(貸方)には同じ科目を登録できません")
      end   
    end 
  end  
    
  # 各科目の合計金額の整合性を確認する
  validate :money_check
  def money_check
    
    # 仕訳帳は1/1から順番に記帳しないと矛盾が生じてエラーが多発しやすいです。
    # エラーチェックを解除したい場合は次のコードを有効にして下さい。
    # return
  
    # 現金 
    total = get_account_total(:m1,3,id)
    if(total < 0)
      errors.add(:dummy, "現金の合計が"+ total.to_s(:delimited) +"円になります。この仕訳の前に「借方」に現金を追加して下さい 例)借方(現金) 貸方(事業主借)")
    end
    
    # その他の預金 
    total = get_account_total(:m2,4,id)
    if(total < 0)
      errors.add(:dummy, "その他の預金の合計が"+ total.to_s(:delimited) +"円になります。※他の仕訳の「その他の預金」を確認して下さい")
    end
    
    # 前払金 
    total = get_account_total(:m3,13,id)
    if(total < 0)
      errors.add(:dummy, "前払金の合計が"+ total.to_s(:delimited) +"円になります。※他の仕訳の「前払金」を確認して下さい")
    end
    
    # 未払金 
    total = get_account_total(:m4,5,id)
    if(total > 0)
      errors.add(:dummy, "このままだと未払金を支払い過ぎます。("+ total.to_s(:delimited) +"円多い) ※他の仕訳の「未払金」を確認して下さい")
    end      
  end  
end
