# The Utility

This hack is a simple ruby library to obtain from the [apple developer portal's member center] (https://developer.apple.com/account/overview.action) provisioning profiles and certificates that need attention.  These include:
    - invalid certificates, those that are not in the Issued state
    - invalid provisioning profiles, those that are not in the Invalid state
    - expiring certifcates
    - expiring provisioning profiles 

# Requirements

This hack depends on [Cupertino](https://github.com/nomad/Cupertino) set of utilities, they should be installed from the Gemfile. 

# Warning - There Be Dragons
The Cupertino package is effectively a screen scraper to the apple site, and at anytime it can change so the scripts don't run.

# Setting Up

Ensure user's apple developer account credentials are in the keychain, using the [Cupertino](https://github.com/nomad/Cupertino) `ios login` command line utility.  Alternatively, you can login from code, in wrapper script, but one's credentials are in the clear and this is ill advised:

It is envisioned the utilities here will be wrapped in a script.

````
aget = Cupertino::ProvisioningPortal::Agent.new
aget.username = "some.one@there.com"
aget.password = "foo"
````

# Usage

````ruby
# connect to the developer portal using the keychain saved credentials
aget = Cupertino::ProvisioningPortal::Agent.new

# get the development certificates needing
# attention (expiring in 57 days or invalid)
dev_certs_needing_attention = Certificates.new(aget.list_certificates, Date.today, 57)

dev_certs_needing_attention.expired.each do |cert|
    puts cert
end

dev_certs_needing_attention.not_valid.each do |cert|
    puts cert
end

# do the same for the distribution certificates
distribution_certs_needing_attention = Certificates.new(aget.list_certificates(:distribution), Date.today, 57)


# and for provisiong profiles, dev and distribtions
# use the same .expired and ._not_valid accessors
#
dev_provisioning_profiles = ProvisioningProfiles.new(aget.list_profiles, Date.today, 57)


distribution_provisioning_profiles = ProvisioningProfiles.new(aget.list_profiles(:distribution), Date.today, 57)

# aget.list_profiles
# aget.list_profiles(:distribution)

````
