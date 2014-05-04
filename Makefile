all: binary docs package ;

binary: nuget_packages_restore
	xbuild CoreTweet.sln /p:Configuration=Release

docs: external_tools binary
	scripts/makedoc.sh

# NuSpec

nuspec: 
	cp nuspecs/CoreTweet-Mono.nuspec Binary/Nightly/CoreTweet.nuspec
	cp nuspecs/CoreTweet.Streaming.Reactive-Mono.nuspec Binary/Nightly/CoreTweet.Streaming.Reactive.nuspec

# External tools

external_tools: ExternalDependencies/doxygen/bin/doxygen ExternalDependencies/nuget/bin/nuget

ExternalDependencies/doxygen/bin/doxygen:
	cd ExternalDependencies/doxygen
	./configure
	make

ExternalDependencies/nuget/bin/nuget:
	cd ExternalDependencies/nuget
	make

# NuGet

nuget_packages_restore:
	[ -f packages/repositories.config ] || scripts/nuget_restore.sh

package: external_tools binary nuspec
	scripts/nuget_pack.sh

# Clean

clean:
	rm -rf Binary/Nightly

# Nonfree

binary-nonfree:
	make -f Makefile-nonfree binary

package-nonfree:
	make -f Makefile-nonfree package