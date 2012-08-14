# this fixes the issue with 1.8.7 where strict_encode doesn't exist
unless Base64.respond_to? :strict_encode64
  module Base64
    def strict_encode64(bin)
      [bin].pack('m0')
    end
  end
end