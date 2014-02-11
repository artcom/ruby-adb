require 'adb'


describe Adb::Wrapper do
  subject(:adb) { Adb::Wrapper.new }

  it 'returns the version' do
    expect(adb.version).to eq('1.0.31')
  end
end
