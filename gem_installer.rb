class GemInstaller < Tango::Runner
  step 'install' do |gem_name|
    met? { shell('gem', 'list', gem_name).output.include?(gem_name) }
    meet { shell('gem', 'install', gem_name) }
  end
end
