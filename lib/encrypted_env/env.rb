module EncryptedEnv
  module ENV
    def encrypt(key,value,options={})
      EncryptedEnv.encrypt(key,value,options)
    end

    def decrypt(key,options={})
      EncryptedEnv.decrypt(key,options)
    end
  end
end