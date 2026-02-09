if [ -f "$CCMANAGER_GIT_ROOT/.env" ] && [ ! -f .env ]; then
  cp "$CCMANAGER_GIT_ROOT/.env" .env
fi

# Prepare the working directory as well
mkdir -p "$CCMANAGER_WORKTREE_PATH/.tmp"

# Existing startup and indexing
code-insiders "$CCMANAGER_WORKTREE_PATH"
uvx --from git+https://github.com/oraios/serena serena project index
