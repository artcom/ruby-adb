module Adb
  class Wrapper
    def initialize(path: 'adb', device: nil)
      @command = path
      @command << " -s #{device}" unless device.nil?
    end

    def version
      output = adb ['version']
      output.match(/Android Debug Bridge version ([\d\.]+)/)[1]
    end

    def install(apk)
      output = adb ['install', apk]
      true
    end

    def uninstall(apk)
      output = adb ['uninstall', apk]
      true
    end

    private

    def adb(arguments)
      `#{@command} #{arguments.join(' ')}`
    end
  end
end
