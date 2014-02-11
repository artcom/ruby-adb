require 'adb'


describe Adb::Wrapper do
  subject(:adb) { Adb::Wrapper.new }

  it 'returns the version' do
    allow(adb).to receive(:`).with('adb version').and_return("Android Debug Bridge version 23.42.1\n")
    expect(adb.version).to eq('23.42.1')
  end
end
