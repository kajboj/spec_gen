require_relative 'constant_replacer'

module Spec
  def self.add line
    @s ||= ''
    @s += line
  end

  def self.get
    @s
  end
end

class O
  def initialize(object_name)
    @object_name = object_name
  end

  def method_missing(m, *args, &blk)
    if args.any?
      puts "#{@object_name}.stub(:#{m}).with(#{args.join(', ')}).and_return(#{m})"
    else
      puts "#{@object_name}.stub(:#{m}).and_return(#{m})"
    end

    O.new(m)
  end

  def to_str
    @object_name.to_s
  end
end

class M
  def initialize(const_name)
    @const_name = const_name
  end

  def method_missing(m, *args, &blk)
    new_object = @const_name.split('::').last.downcase

    puts "#{new_object} = double('#{new_object}')"
    puts "#{@const_name}.stub(:#{m}).with(#{args.join(', ')}).and_return(#{new_object})"

    O.new(new_object.to_s)
  end
end

class ExecutionContext
  def self.method_missing(m, *args, &blk)
    O.new(m.to_s)
  end

  def self.run(code)
    eval(code)
  end
end

class GenSpec
  def initialize(filename)
    @code = File.read(filename)
  end

  def code_with_replaced_constants
    ConstantReplacer.new(@code).result
  end

  def generate
    ExecutionContext.run(
      code_with_replaced_constants)
  end
end

gen_spec = GenSpec.new('spec/fixtures/logger.rb')

puts gen_spec.generate 

puts Spec.get