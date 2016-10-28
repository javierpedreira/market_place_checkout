class Promotion
  attr_reader :threshold, :value
  def initialize(threshold, benefit)
    @threshold = threshold
    @value = benefit
  end

  def applicable?(value)
    value >= @threshold
  end
end
