require 'adb'
require 'active_support/core_ext/string/strip'

describe Adb::Wrapper do
  subject(:adb) { Adb::Wrapper.new(path: 'adb') }

  context 'without a device' do
    it 'lists no devices' do
      allow(adb).to receive(:`)
        .with('adb devices 2>&1')
        .and_return <<-EOS.strip_heredoc
        List of devices attached
      EOS

      devices = adb.devices
      expect(devices).to have(0).item
    end

    it 'throws when trying to reboot' do
      allow(adb).to receive(:`)
        .with('adb reboot 2>&1')
        .and_return 'error: device not found'

      expect { adb.reboot }.to raise_error(
        Adb::Error,
        'error: device not found'
      )
    end
  end

  context 'with an unspecified device' do
    it 'returns the version' do
      allow(adb).to receive(:`)
        .with('adb version 2>&1')
        .and_return("Android Debug Bridge version 23.42.1\n")

      expect(adb.version).to eq('23.42.1')
    end

    it 'lists connected devices' do
      allow(adb).to receive(:`)
        .with('adb devices 2>&1')
        .and_return <<-EOS.strip_heredoc
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
      allow(adb).to receive(:`).with("adb install #{apk} 2>&1")
      adb.install apk
    end

    it 'uninstalls a package' do
      package_name = 'com.example.test'
      allow(adb).to receive(:`).with("adb uninstall #{package_name} 2>&1")
      adb.uninstall package_name
    end

    it 'reboots the device' do
      allow(adb).to receive(:`).with('adb reboot 2>&1')
      adb.reboot
    end
  end

  context 'with a specified device' do
    let(:device) { '386ef2b0' }

    it 'installs a package' do
      apk = 'path_to/my.apk'
      allow(adb).to receive(:`).with("adb -s #{device} install #{apk} 2>&1")
      adb.install apk, device: device
    end

    it 'uninstalls a package' do
      package_name = 'com.example.test'
      allow(adb).to receive(:`)
        .with("adb -s #{device} uninstall #{package_name} 2>&1")

      adb.uninstall package_name, device: device
    end

    it 'reboots the device' do
      allow(adb).to receive(:`).with("adb -s #{device} reboot 2>&1")
      adb.reboot device: device
    end
  end
end
