default[:np_couchpotato].tap do |cp|
  cp[:install_path] = '/opt/couchpotato'

  # sabznbd settings
  cp[:sabznbd].tap do |sab|
    sab[:enable] = false

    sab[:host] = 'localhost'
    sab[:port] = 8080

    sab[:api_key][:data_bag]      = 'couchpotato'
    sab[:api_key][:data_bag_item] = 'secrets'
  end
end
