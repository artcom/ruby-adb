require 'adb'


describe AdbWrapper do
  subject(:adb) { AdbWrapper.new }

  it 'returns the version' do
    expect(adb.version).to equal '1.0.31'
  end
end
