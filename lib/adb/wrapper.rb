module Adb
  class Wrapper
    def initialize(path: 'adb')
      @path = path
    end

    def version
      output = adb ['version']
      output.match(/Android Debug Bridge version ([\d\.]+)/)[1]
    end

    def install(apk)
      output = adb ['install', apk]
      true
    end

    private

    def adb(arguments)
      `#{@path} #{arguments.join(' ')}`
    end
  end
end
