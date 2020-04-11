#initialize pages by method

class System

  def self.anypage
    AnyPage.new
  end

  def self.fhome
    FHome.new
  end

  def self.fbilling
    FBilling.new
  end

  def self.freview
    FReview.new
  end

  def self.freceipt
    FReceipt.new
  end

end
