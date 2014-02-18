module Adb
  class Error < RuntimeError; end

  ##
  # Wrapper for Android adb command line tool
  class Wrapper
    def initialize(path: "#{ENV['ANDROID_HOME']}/platform-tools/adb")
      @path = path
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

    def install(apk, **options)
      adb ['install', apk], options
      true
    end

    def uninstall(apk, **options)
      adb ['uninstall', apk], options
      true
    end

    def reboot(**options)
      output = adb ['reboot'], options
      fail Error, output unless output.nil? || output.empty?
    end

    private

    def adb(arguments, **options)
      command = @path
      command << " -s #{options[:device]}" if options.key?(:device)
      `#{command} #{arguments.join(' ')} 2>&1`
    end
  end
end
