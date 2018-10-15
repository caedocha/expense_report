require 'csv'
require 'rubyxl'
require_relative './expenses'
require_relative './cursor'

def parse_expense_csv(csv)
  csv_encoding = 'iso-8859-1:utf-8'
  CSV.foreach(csv, encoding: csv_encoding)
end

def parse_expense_rows(csvs:)
  csvs.flat_map do |expense_file|
    parse_expense_csv(expense_file).map { |row| row }
  end
end

def write_expenses_by_category_to_xlsx(expenses, workbook, path_to_write_to)
  worksheet = workbook.worksheets.first
  cursor = Cursor.new(worksheet: worksheet)

  expenses
    .group_by_category
    .map do |(category, expenses)|
      cursor.add_to_next_cell(category)
      expenses
        .group_by_detail
        .sort_by { |(detail, expenses)| expenses.total }
        .reverse
        .each { |(detail, expenses)| cursor.add_to_next_cell(detail, expenses.total.round) }
    end
  workbook.write(path_to_write_to)
end

def write_monthly_expenses_to_xlsx(expenses, workbook, path_to_write_to)
  worksheet = workbook.add_worksheet('Monthly expenses')
  cursor = Cursor.new(worksheet: worksheet)

  expenses
    .group_by_month
    .map do |(month, expenses)|
      cursor.add_to_next_cell(month)
      expenses
        .group_by_category
        .sort_by { |(category, expenses)| expenses.total }
        .reverse
        .each { |(category, expenses)| cursor.add_to_next_cell(category, expenses.total.round) }
    end
  workbook.write(path_to_write_to)
end

def main
  path_to_csvs = ARGV[0]
  path_to_write_to = ARGV[1]
  rows = parse_expense_rows(csvs: Dir[path_to_csvs])
  expenses = Expenses.new(csv_rows: rows)
  workbook = RubyXL::Workbook.new

  write_expenses_by_category_to_xlsx(expenses, workbook, path_to_write_to)
  write_monthly_expenses_to_xlsx(expenses, workbook, path_to_write_to)
end

main
