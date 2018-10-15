require_relative './expense_date'

class Expense

  attr_reader :date
  attr_reader :detail
  attr_reader :amount
  attr_reader :knowledge

  def initialize(date:, detail:, amount:)
    @date = ExpenseDate.new(date)
    @detail = detail.strip
    @amount = amount.strip.to_f
    @knowledge = CategoryKnowledge.new
  end

  def expense?
    date.valid? && !profit?
  end

  def month
    date.month
  end

  def category
    knowledge.classify(detail)
  end

  private

  def profit?
    amount < 0
  end

end
