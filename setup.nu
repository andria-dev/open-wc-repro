#!/usr/bin/env nu

print "> yarn create @open-wc";
match ("./my-component" | path type) {
	"dir" => {
		print "[Info]: ./my-component directory already exists.";
	},
	"file" => {
		print "[Error]: ./my-component is a file.";
		exit;
	},
	_ => {
		let yarn_result = yarn create @open-wc --destinationPath ./my-component --type scaffold --scaffoldType wc --features demoing --typescript true --tagName my-component --installDependencies yarn --writeToDisk true | complete;
		if $yarn_result.exit_code != 0 {
			print yarn_result.stderr;
			print $"[Error]: failed with exit code ($yarn_result.exit_code).";
			exit;
		};
		print "[Info]: @open-wc project created!";
	}
}
print "> cd ./my-component";
cd ./my-component;

try { open .yarnrc.yml } | default {} | merge { nodeLinker: "node-modules" } | to yaml | save --force .yarnrc.yml;
print "[Info]: Changed Yarn nodeLinker to node-modules.";

print "> yarn install";
yarn install | ignore;

print "> yarn add -D react react-dom";
yarn add -D react react-dom | ignore;

print "You're good to go!";
