require 'cupertino/provisioning_portal'

# ensure $ios login is performed and no need to credentialise
# in email provisioning bundle id, "profile name" and date of expiration

#aget.username = "some.one@there.com"
#aget.password = "foo"

module AppleDevAssetsUtilities
  class ExpirableAppleDevAsset
    attr_reader :expired, :not_valid

    def initialize(assets, from_date, days_away)
      @not_valid = []
      assets.each do |asset|
        @not_valid.push(asset) unless valid?(asset)
      end

      @expired = []
      assets.each do |asset|
        @expired.push(asset) if expired?(asset, from_date, days_away)
      end
    end

    def valid?(asset)
      raise NotImplementedError    
    end

    def expired?(asset, from_date, days_away)
      raise NotImplementedError
    end  
  end 

  class Certificates < ExpirableAppleDevAsset
    def initialize(assets, from_date, days_away)
      super(assets, from_date, days_away)
    end

    def valid?(cert)
      cert.status == "Issued"
    end

    def expired?(cert, from_date, days_away)
      ((cert.expiration - from_date).to_i - days_away) <= 0
    end  
  end 

  class ProvisioningProfiles < ExpirableAppleDevAsset
    def initialize(profiles, from_date, days_away)
      super(profiles, from_date, days_away)
    end

    def valid?(profile)
      profile.status != "Invalid"
    end

    def expired?(profile, from_date, days_away)
      ((profile.expiration.to_date - from_date).to_i - days_away) <= 0
    end  
  end 
end



