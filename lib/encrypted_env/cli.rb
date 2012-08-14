require 'thor'
require 'encrypted_env'

module EncryptedEnv
  class Cli < Thor
    desc "bash key=value key1=value1 ...", "prints output that bash can understand"
    method_option :key, :aliases => '-k', :type => :string, :required => true
    def bash(*args)
      encrypt(*args) do |key,value|
        puts %Q(export "#{key}"="#{value}")
      end
    end

    desc "heroku key=value key1=value1 ...", 'prints output that heroku can understand'
    method_option :remote, :aliases => '-r', :type => :string
    method_option :key, :aliases => '-k', :type => :string, :required => true
    def heroku(*args)
      heroku_opt = "-r #{options[:remote]}" if options[:remote]
      encrypt(*args) do |key,value|
        puts %Q(heroku config:add #{heroku_opt} "#{key}=#{value}")
      end
    end

    no_tasks do
      def encrypt(*args, &block)
        EncryptedEnv.default_options = {:key => options[:key]}
        args.each do |arg|
          key,value = arg.split('=')
          yield key, EncryptedEnv.encrypt(value)
        end
      end
    end

    desc 'decrypt key ...', 'Decrypts a key in the ENV'
    method_option :key, :aliases => '-k', :type => :string, :required => true
    def decrypt(*args)
      EncryptedEnv.default_options = {:key => options[:key]}
      args.each do |key|
        puts "#{key}: #{::ENV.decrypt key}" rescue nil
      end
    end
  end
end