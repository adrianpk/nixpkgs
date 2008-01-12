args : with args;
	with builderDefs {
		addSbinPath = true;
		src = "";
		buildInputs = [module_init_tools];
		configureFlags = [];
	} null; /* null is a terminator for sumArgs */
let 

doCollect = FullDepEntry (''
ensureDir $out/lib/modules
cd $out/
for i in $moduleSources; do 
	cp -rs $i/lib/modules lib/
        chmod -R u+w lib/
done
cd lib/modules/
rm */modules.*
MODULE_DIR=$PWD/ depmod -a 
'') [minInit addInputs defEnsureDir];
in
stdenv.mkDerivation rec {
	name = "kernel-modules";
	inherit moduleSources;
	builder = writeScript (name + "-builder")
		(textClosure [doCollect doForceShare doPropagate]);
	meta = {
		description = "
		A directory to hold all  the modules, including those 
		built separately from kernel. Earlier directories in 
		moduleSources have higher priority.
";
	};
}
