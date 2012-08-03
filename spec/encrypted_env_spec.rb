require 'spec_helper'

describe EncryptedEnv do
  before do
    EncryptedEnv.class_eval "@default_options = nil"
  end

  context "#default_options" do
    it 'should be Encryptor default value' do
      EncryptedEnv.default_options.should == ::Encryptor.default_options
    end

    it 'should return overridden values' do
      # maybe it isn't good to depend on this function, but it should work
      EncryptedEnv.default_options = {:foo => :bar}
      Encryptor.should_not_receive(:default_options)

      EncryptedEnv.default_options[:foo].should == :bar
    end
  end

  context "#default_options=" do
    it 'should store any key passed' do
      EncryptedEnv.default_options = {:key => :value}

      EncryptedEnv.default_options.should include(:key)
    end

    it 'should allow rewriting of any previously written key' do
      EncryptedEnv.default_options = {:algorithm => :bf}

      EncryptedEnv.default_options[:algorithm].should == :bf
    end
  end

  context "#encrypt" do
    it 'should return the encrypted value' do
      # we can't actually write to the env directly, but we can print a value that can be used directly
      EncryptedEnv.encrypt('this is a test', :key => 'test').should_not be_nil
    end

    it 'should pass all optional args merged with defaults to the Encryptor' do
      Encryptor.should_receive(:encrypt).with(Encryptor.default_options.merge(:foo => :bar, :baz => :aaa, :value => 'value', :key => 'test'))
      EncryptedEnv.default_options = {:foo => :bar}

      EncryptedEnv.encrypt(:value, :baz => :aaa, :key => 'test')
    end

    it 'should base64 encode the value before dumping in the ENV' do
      value = Encryptor.encrypt(:value => 'this is a test', :key => 'test')
      Base64.should_receive(:encode64).with(value)

      EncryptedEnv.encrypt('this is a test', :key => 'test')
    end
  end

  context "#decrypt" do
    before do
      EncryptedEnv.default_options = {:key => 'hello world'}
      @value = EncryptedEnv.encrypt('testing')
      EncryptedEnv.env = {'TEST_VALUE' => @value}
    end


    it 'should pass all optional args merged with defaults to the Encryptor' do
      Encryptor.should_receive(:decrypt).with(
        Encryptor.default_options.merge(:foo => :bar, :baz => :aaa,:key => 'hello world',:value => Base64.decode64(@value))
      )
      EncryptedEnv.default_options = {:foo => :bar}

      EncryptedEnv.decrypt('TEST_VALUE', :baz => :aaa)
    end

    it 'should base64 decode the ENV before processing' do
      decoded = Base64.decode64 EncryptedEnv.env['TEST_VALUE']
      Base64.should_receive(:decode64).with(@value).and_return decoded

      EncryptedEnv.decrypt('TEST_VALUE')
    end

    it 'should return the decrypted value of the key' do
      EncryptedEnv.decrypt('TEST_VALUE').should == 'testing'
    end
  end
end