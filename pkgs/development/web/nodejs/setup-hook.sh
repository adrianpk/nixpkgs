addNodePath () {
    addToSearchPath NODE_PATH $1/lib/node_modules
}

envHooks+=(addNodePath)
