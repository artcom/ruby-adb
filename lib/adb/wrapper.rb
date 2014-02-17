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

      unless output.nil?
        last_line = output.lines.to_a.last
        error = /error: (.*)/.match(last_line)
        fail Error, error[1] unless error.nil?
      end
    end

    private

    def adb(arguments)
      `#{@command} #{arguments.join(' ')}`
    end
  end
end
