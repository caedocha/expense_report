class ExpenseDate

  MONTH_TRANSLATIONS = {
    'ENE': 'JAN',
    'FEB': 'FEB',
    'MAR': 'MAR',
    'ABR': 'APR',
    'MAY': 'MAY',
    'JUN': 'JUN',
    'JUL': 'JUL',
    'AGO': 'AUG',
    'SEP': 'SEP',
    'OCT': 'OCT',
    'NOV': 'NOV',
    'DIC': 'DEC'
  }

  def initialize(spanish_date)
    @spanish_date = spanish_date
  end

  def to_date
    Date.parse(translate)
  end

  def valid?
    return false if nil?

    mmm_dd?
  end

  def nil?
    @spanish_date.nil?
  end

  def month
    to_date.strftime('%b').upcase
  end

  private

  def mmm_dd?
    /[A-Z]{3}\/\d{2}/ =~ @spanish_date
  end

  def translate
    month = MONTH_TRANSLATIONS[@spanish_date.split('/').first.to_sym];
    day = @spanish_date.split('/').last;
    "#{month}/#{day}"
  end

end
