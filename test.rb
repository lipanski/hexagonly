class Test
  module Methods
    def hello
      puts "hello"
    end
  end

  include Methods

  def initialize
    puts "init"
  end
end

class SecondTest
  include Test::Methods
end

Test.new.hello
SecondTest.new.hello