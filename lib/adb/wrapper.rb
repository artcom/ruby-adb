module Adb
  class Wrapper
    def initialize(path: 'adb')
      @path = path
    end

    def version
      output = adb %w(version)
      output.match(/Android Debug Bridge version ([\d\.]+)/)[1]
    end

    private

    def adb(arguments)
      `#{@path} #{arguments.join(' ')}`
    end
  end
end
