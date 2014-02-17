module Adb
  class Error < RuntimeError; end

  ##
  # Wrapper for Android adb command line tool
  class Wrapper
    def initialize(
      path: "#{ENV['ANDROID_HOME']}/platform-tools/adb",
      device: nil)

      @command = path
      @command << " -s #{device}" unless device.nil?
    end

    def version
      output = adb ['version']
      output.match(/Android Debug Bridge version ([\d\.]+)/)[1]
    end

    def devices
      output = adb ['devices']
      device_strings = output.lines.select { |line| line.match(/\tdevice$/) }
      device_strings.map { |line| line.split("\t")[0] }
    end

    def install(apk)
      adb ['install', apk]
      true
    end

    def uninstall(apk)
      adb ['uninstall', apk]
      true
    end

    def reboot
      output = adb ['reboot']
      fail Error, output unless output.nil?
    end

    private

    def adb(arguments)
      `#{@command} #{arguments.join(' ')} 2>&1`
    end
  end
end
