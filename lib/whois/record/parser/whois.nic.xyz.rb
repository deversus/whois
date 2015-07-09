#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/whois.centralnic.com.rb'

module Whois
  class Record
    class Parser
      class WhoisNicXyz < WhoisCentralnicCom
        property_supported :status do
          # OK, RENEW PERIOD, ...
          Array.wrap(
            node("Status") ||
            node("Domain Status")
          )
        end

        property_supported :created_on do
          node("Created On")  { |str| Time.parse(str) } ||
          node("Creation Date") { |str| Time.parse(str) }
        end

        property_supported :updated_on do
          node("Last Updated On") { |str| Time.parse(str) } ||
          node("Updated Date") { |str| Time.parse(str) }
        end

        property_supported :expires_on do
          node("Expiration Date") { |str| Time.parse(str) } ||
          node("Registry Expiry Date") { |str| Time.parse(str) }
        end

        property_supported :registrar do
          node("Sponsoring Registrar ID") do
            Record::Registrar.new(
                :id           => node("Sponsoring Registrar ID"),
                :name         => nil,
                :organization => node("Sponsoring Registrar Organization"),
                :url          => node("Sponsoring Registrar Website")
            )
          end ||
          node("Sponsoring Registrar IANA ID") do
            Record::Registrar.new(
                :id           => node("Sponsoring Registrar IANA ID"),
                :name         => node("Sponsoring Registrar"),
                :organization => nil,
                :url          => nil
            )
          end
        end
      end
    end
  end
end
