require 'adb'
require 'active_support/core_ext/string/strip'


describe Adb::Wrapper do
  context 'without specific device' do
    subject(:adb) { Adb::Wrapper.new }

    it 'returns the version' do
      allow(adb).to receive(:`).with('adb version').and_return("Android Debug Bridge version 23.42.1\n")
      expect(adb.version).to eq('23.42.1')
    end

    it 'lists connected devices' do
      allow(adb).to receive(:`).with('adb devices').and_return <<-EOS.strip_heredoc
        * daemon not running. starting it now on port 5037 *
        * daemon started successfully *

        List of devices attached 
        386ef2b0	device
      EOS

      devices = adb.devices
      expect(devices).to have(1).item
      expect(devices).to include('386ef2b0')
    end

    it 'installs a package' do
      apk = 'path_to/my.apk'
      allow(adb).to receive(:`).with("adb install #{apk}")
      adb.install apk
    end

    it 'uninstalls a package' do
      package_name = 'com.example.test'
      allow(adb).to receive(:`).with("adb uninstall #{package_name}")
      adb.uninstall package_name
    end
  end

  context 'for a specific device' do
    let(:device) { '386ef2b0' }
    subject(:adb) { Adb::Wrapper.new device: device }

    it 'installs a package' do
      apk = 'path_to/my.apk'
      allow(adb).to receive(:`).with("adb -s #{device} install #{apk}")
      adb.install apk
    end

    it 'uninstalls a package' do
      package_name = 'com.example.test'
      allow(adb).to receive(:`).with("adb -s #{device} uninstall #{package_name}")
      adb.uninstall package_name
    end
  end
end
