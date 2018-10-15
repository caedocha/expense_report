require_relative './expense'
require_relative './category_knowledge'

class Expenses

  include Enumerable

  attr_reader :expenses
  attr_reader :csv_rows

  def initialize(csv_rows: nil, expenses: nil)
    @csv_rows = csv_rows
    @expenses = expenses.nil? ? build_expenses_from_csv_rows : expenses
  end

  def size
    expenses.size
  end

  def each(&block)
    expenses.each(&block)
  end

  def group_by_month
    group_by { |expense| expense.month }
      .map { |(month, expenses)| [month, Expenses.new(expenses: expenses)] }
      .to_h
  end

  def group_by_detail
    group_by { |expense| expense.detail }
      .map { |(detail, expenses)| [detail, Expenses.new(expenses: expenses)] }
      .to_h
  end

  def group_by_category
    group_by { |expense| expense.category }
      .map { |(category, expenses)| [category, Expenses.new(expenses: expenses)] }
      .to_h
  end

  def total
    expenses.reduce(0) { |total, expense| total + expense.amount }
  end

  private

  def build_expenses_from_csv_rows
    csv_rows.map do |row|
      Expense.new(date: row[0], detail: row[1], amount: row[2])
    end.select(&:expense?)

  end

end
