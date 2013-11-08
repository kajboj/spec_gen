class ConstantReplacer
  def initialize(code)
    @code = code
  end

  def result
    r = @code.dup

    a = ''
    b = @code.dup
    while match_start = (b =~ /([A-Z]\w*::)*[A-Z]\w+/) do
      match = $~.to_s
      match_finish = match_start + match.length
      replacement = "M.new('#{match}')"
      a += b[0..match_start-1] + replacement
      b = b[match_finish..-1]
      i = match_start + match.length
    end

    a + b
  end
end