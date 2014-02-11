require 'adb'


describe Adb::Wrapper do
  context 'without specific device' do
    subject(:adb) { Adb::Wrapper.new }

    it 'returns the version' do
      allow(adb).to receive(:`).with('adb version').and_return("Android Debug Bridge version 23.42.1\n")
      expect(adb.version).to eq('23.42.1')
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
