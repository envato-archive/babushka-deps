# Copy-pasted from benhoskings' deps in order to remove it as an external
# dependency for our production environment.

dep 'zlib headers.managed' do
  installs { via :apt, 'zlib1g-dev' }
  provides []
end

