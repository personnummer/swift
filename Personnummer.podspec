
Pod::Spec.new do |s|
	s.name 		= 'Personnummer'
	s.version 	= '1.0.2'
	s.author 	= { 'Arbitur' => 'arbiturr@gmail.com' }
	s.license 	= { :type => 'MIT', :file => 'LICENSE' }
	s.homepage 	= 'https://github.com/personnummer/swift.git'
	s.source 	= { :git => s.homepage, :tag => s.version, :branch => 'master' }
	s.summary 	= 'Validate and format Swedish personal identity numbers'

	s.platform = :ios, '10.0'
	s.swift_version = '4.2'

	s.frameworks = 'Foundation'
	s.source_files = 'source/*.swift'

end
