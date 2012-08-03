require 'spec_helper'

describe ENV do
  context "#encypt" do
    it 'should be a pass through to EncryptedEnv.encrypt method' do
      EncryptedEnv.should_receive(:encrypt).with(:foo, :bar, :key => :baz)

      ENV.encrypt(:foo, :bar, :key => :baz)
    end
  end

  context "#decrypt" do
    it 'should be a pass through to EncryptedEnv.decrypt method' do
      EncryptedEnv.should_receive(:decrypt).with(:foo, :key => :baz)

      ENV.decrypt(:foo, :key => :baz)
    end
  end
end